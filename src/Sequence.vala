using Gdk;
using Plank;
using Posix;

namespace Capture {

	public class Sequence {

		protected List<Pixbuf> pixbufs;
		public uint frame { get; protected set; }
		public uint framerate {get; set; }



		public Sequence() {
			pixbufs = new List<Pixbuf>();
			frame = 0;
		}



		public void add(Pixbuf pixbuf) {
			pixbufs.append(pixbuf);	
		}



		public uint length() {
			return pixbufs.length();
		}



		public Pixbuf? first() {

			GLib.assert (pixbufs.length() > 0);

			return pixbufs.nth_data(0);
		}


			
		public Pixbuf? next() {

			GLib.assert (pixbufs.length() > 0);

			if (++frame >= length()) {
				frame = 0;
			}
			return pixbufs.nth_data(frame);
		}



		public Pixbuf? previous() {

			GLib.assert (pixbufs.length() > 0);

			if (frame == 0) {
				frame = pixbufs.length() - 1;
			}
			else {
				frame--;
			}
			return pixbufs.nth_data(frame);
		}

		public bool save_to_animated_gif(string filename) {
			
			string dirname = GLib.Path.build_path(
				Path.DIR_SEPARATOR_S,
				Environment.get_tmp_dir(),
				"capture",
				new DateTime.now_local().to_unix().to_string()
			);
			Logger.notification("Creating temp dir: %s".printf(dirname));

			try  {
				File dir = File.new_for_path(dirname);
				dir.make_directory_with_parents();
			}
			catch (Error e) {
				warning("Could not create directory: %s: %s", dirname, e.message);
				return false;
			}

			var win = new Gtk.Window(Gtk.WindowType.TOPLEVEL);
			var vbox = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
			var progress_bar = new Gtk.ProgressBar();
			vbox.pack_start(progress_bar, true, false, 0);
			var cancel_button = new Gtk.Button.with_label(("Cancel"));
			cancel_button.set_sensitive(false);
			vbox.pack_start(cancel_button);
			win.add(vbox);
			win.show_all();
			win.present();

			uint n = 1;
			uint m = pixbufs.length() + 1;

			foreach (Pixbuf pixbuf in pixbufs) {
				try {

					string frame_filename = GLib.Path.build_filename(
						dirname,
						"frame-%04u".printf(n++)
					);
					Logger.notification("Saving frame %s".printf(frame_filename));
					pixbuf.save(frame_filename, "png");
					progress_bar.set_fraction(n / m);
				}
				catch (Error e) {
					warning("Failed to save pixbuf: %s", e.message);
					break;
				}
			}

			if (n != m) {
				warning("Could not save all frames (%u of %u), aborting conversion to gif", n, m);
				return false;
			}

			Logger.notification("Now calling convert, this can take some time...");

			try {
				MainLoop loop = new MainLoop();

				string tmp_filename = GLib.Path.build_filename(dirname, "tmp.gif");

				string delay = (100 / framerate).to_string();
				string args[] = {"/usr/bin/convert", "-delay", delay, "-loop", "0", "*", tmp_filename, null};
				/* string env  = null;// Environ.get(); */
				Pid child_pid;
				Process.spawn_async(
					dirname,
					args,
					null,
					SpawnFlags.SEARCH_PATH | SpawnFlags.DO_NOT_REAP_CHILD,
					null,
					out child_pid
				);

				Logger.notification("Spawned process with PID: %u".printf(child_pid));
				cancel_button.set_sensitive(true);
				cancel_button.clicked.connect( () => {
					Posix.kill(child_pid, ProcessSignal.TERM);
				});

				ChildWatch.add(child_pid, (pid, status) => {
					Logger.notification("Child exited with status: %u".printf(status));
					Process.close_pid(pid);

					// TODO: Handle status;
					string args2[] = {"/usr/bin/convert", "-layers", "Optimize", tmp_filename, filename, null};
					Process.spawn_async(dirname, args2, null, SpawnFlags.SEARCH_PATH | SpawnFlags.DO_NOT_REAP_CHILD, null, out child_pid);
					// Cancel button should still handle the (now new) child_pid??

					ChildWatch.add(child_pid, (pid, status) => {
						Logger.notification("Child exited with status: %u".printf(status));
						Process.close_pid(pid);

						// TODO: Handle status;

						loop.quit();
						win.destroy();
					});
				});

				Timeout.add(250, () => {
					progress_bar.pulse();
					return true;

				});
				loop.run();
			}
			catch (SpawnError e) {
				warning("Error: %s", e.message);
				return false;
			}

			return true;
		}
	}
}
