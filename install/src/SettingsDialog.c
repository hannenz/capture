/* SettingsDialog.c generated by valac 0.34.4, the Vala compiler
 * generated from SettingsDialog.vala, do not modify */


#include <glib.h>
#include <glib-object.h>
#include <gtk/gtk.h>
#include <gio/gio.h>
#include <granite.h>
#include <glib/gi18n-lib.h>
#include <float.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include <plank.h>
#include <locale.h>


#define CAPTURE_TYPE_SETTINGS_DIALOG (capture_settings_dialog_get_type ())
#define CAPTURE_SETTINGS_DIALOG(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), CAPTURE_TYPE_SETTINGS_DIALOG, CaptureSettingsDialog))
#define CAPTURE_SETTINGS_DIALOG_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), CAPTURE_TYPE_SETTINGS_DIALOG, CaptureSettingsDialogClass))
#define CAPTURE_IS_SETTINGS_DIALOG(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), CAPTURE_TYPE_SETTINGS_DIALOG))
#define CAPTURE_IS_SETTINGS_DIALOG_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), CAPTURE_TYPE_SETTINGS_DIALOG))
#define CAPTURE_SETTINGS_DIALOG_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), CAPTURE_TYPE_SETTINGS_DIALOG, CaptureSettingsDialogClass))

typedef struct _CaptureSettingsDialog CaptureSettingsDialog;
typedef struct _CaptureSettingsDialogClass CaptureSettingsDialogClass;
typedef struct _CaptureSettingsDialogPrivate CaptureSettingsDialogPrivate;
#define _g_object_unref0(var) ((var == NULL) ? NULL : (var = (g_object_unref (var), NULL)))
#define _g_free0(var) (var = (g_free (var), NULL))
#define _g_error_free0(var) ((var == NULL) ? NULL : (var = (g_error_free (var), NULL)))

struct _CaptureSettingsDialog {
	GtkDialog parent_instance;
	CaptureSettingsDialogPrivate * priv;
	GSettings* settings;
	GtkSpinButton* countdown_spin_button;
	GtkSpinButton* framerate_spin_button;
	GtkCheckButton* include_pointer_checkbutton;
	GtkCheckButton* auto_save_checkbutton;
	GtkCheckButton* show_notifications_checkbutton;
	GtkCheckButton* copy_to_clipboard_checkbutton;
	GtkFileChooserButton* destination_file_chooser_button;
	GraniteWidgetsModeButton* file_format_mode_button;
};

struct _CaptureSettingsDialogClass {
	GtkDialogClass parent_class;
};


static gpointer capture_settings_dialog_parent_class = NULL;

GType capture_settings_dialog_get_type (void) G_GNUC_CONST;
enum  {
	CAPTURE_SETTINGS_DIALOG_DUMMY_PROPERTY
};
CaptureSettingsDialog* capture_settings_dialog_new (void);
CaptureSettingsDialog* capture_settings_dialog_construct (GType object_type);
static void capture_settings_dialog_create_widgets (CaptureSettingsDialog* self);
static void capture_settings_dialog_connect_signals (CaptureSettingsDialog* self);
static void __lambda11_ (CaptureSettingsDialog* self);
static void ___lambda11__gtk_editable_changed (GtkEditable* _sender, gpointer self);
static void __lambda12_ (CaptureSettingsDialog* self);
static void ___lambda12__gtk_editable_changed (GtkEditable* _sender, gpointer self);
static void __lambda13_ (CaptureSettingsDialog* self);
static void ___lambda13__gtk_toggle_button_toggled (GtkToggleButton* _sender, gpointer self);
static void __lambda14_ (CaptureSettingsDialog* self);
static void ___lambda14__gtk_toggle_button_toggled (GtkToggleButton* _sender, gpointer self);
static void __lambda15_ (CaptureSettingsDialog* self);
static void ___lambda15__gtk_file_chooser_selection_changed (GtkFileChooser* _sender, gpointer self);
static void __lambda16_ (CaptureSettingsDialog* self);
static void ___lambda16__gtk_toggle_button_toggled (GtkToggleButton* _sender, gpointer self);
static void __lambda17_ (CaptureSettingsDialog* self);
static void ___lambda17__gtk_toggle_button_toggled (GtkToggleButton* _sender, gpointer self);
static void __lambda18_ (CaptureSettingsDialog* self);
static void ___lambda18__granite_widgets_mode_button_mode_changed (GraniteWidgetsModeButton* _sender, GtkWidget* widget, gpointer self);
static GObject * capture_settings_dialog_constructor (GType type, guint n_construct_properties, GObjectConstructParam * construct_properties);
#define GETTEXT_PACKAGE "capture"
static void capture_settings_dialog_finalize (GObject* obj);


CaptureSettingsDialog* capture_settings_dialog_construct (GType object_type) {
	CaptureSettingsDialog * self = NULL;
	GSettings* _tmp0_ = NULL;
	const gchar* _tmp1_ = NULL;
	self = (CaptureSettingsDialog*) g_object_new (object_type, NULL);
	_tmp0_ = g_settings_new ("de.hannenz.capture");
	_g_object_unref0 (self->settings);
	self->settings = _tmp0_;
	_tmp1_ = _ ("Settings");
	gtk_window_set_title ((GtkWindow*) self, _tmp1_);
	gtk_container_set_border_width ((GtkContainer*) self, (guint) 10);
	capture_settings_dialog_create_widgets (self);
	capture_settings_dialog_connect_signals (self);
	return self;
}


CaptureSettingsDialog* capture_settings_dialog_new (void) {
	return capture_settings_dialog_construct (CAPTURE_TYPE_SETTINGS_DIALOG);
}


static gpointer _g_object_ref0 (gpointer self) {
	return self ? g_object_ref (self) : NULL;
}


static void capture_settings_dialog_create_widgets (CaptureSettingsDialog* self) {
	GtkBox* content_area = NULL;
	GtkBox* _tmp0_ = NULL;
	GtkBox* _tmp1_ = NULL;
	GtkGrid* grid = NULL;
	GtkGrid* _tmp2_ = NULL;
	GtkGrid* _tmp3_ = NULL;
	GtkGrid* _tmp4_ = NULL;
	GtkBox* _tmp5_ = NULL;
	GtkGrid* _tmp6_ = NULL;
	const gchar* _tmp7_ = NULL;
	gint row = 0;
	GtkGrid* _tmp8_ = NULL;
	const gchar* _tmp9_ = NULL;
	GtkLabel* _tmp10_ = NULL;
	GtkLabel* _tmp11_ = NULL;
	gint _tmp12_ = 0;
	GtkSpinButton* _tmp13_ = NULL;
	GtkSpinButton* _tmp14_ = NULL;
	GSettings* _tmp15_ = NULL;
	gint _tmp16_ = 0;
	GtkGrid* _tmp17_ = NULL;
	GtkSpinButton* _tmp18_ = NULL;
	gint _tmp19_ = 0;
	GtkGrid* _tmp20_ = NULL;
	const gchar* _tmp21_ = NULL;
	GtkLabel* _tmp22_ = NULL;
	GtkLabel* _tmp23_ = NULL;
	gint _tmp24_ = 0;
	GtkSpinButton* _tmp25_ = NULL;
	GtkSpinButton* _tmp26_ = NULL;
	GSettings* _tmp27_ = NULL;
	gint _tmp28_ = 0;
	GtkGrid* _tmp29_ = NULL;
	GtkSpinButton* _tmp30_ = NULL;
	gint _tmp31_ = 0;
	const gchar* _tmp32_ = NULL;
	GtkCheckButton* _tmp33_ = NULL;
	GtkCheckButton* _tmp34_ = NULL;
	GSettings* _tmp35_ = NULL;
	gboolean _tmp36_ = FALSE;
	GtkGrid* _tmp37_ = NULL;
	GtkCheckButton* _tmp38_ = NULL;
	gint _tmp39_ = 0;
	const gchar* _tmp40_ = NULL;
	GtkCheckButton* _tmp41_ = NULL;
	GtkCheckButton* _tmp42_ = NULL;
	GSettings* _tmp43_ = NULL;
	gboolean _tmp44_ = FALSE;
	GtkGrid* _tmp45_ = NULL;
	GtkCheckButton* _tmp46_ = NULL;
	gint _tmp47_ = 0;
	const gchar* _tmp48_ = NULL;
	GtkCheckButton* _tmp49_ = NULL;
	GtkCheckButton* _tmp50_ = NULL;
	GSettings* _tmp51_ = NULL;
	gboolean _tmp52_ = FALSE;
	GtkGrid* _tmp53_ = NULL;
	GtkCheckButton* _tmp54_ = NULL;
	gint _tmp55_ = 0;
	const gchar* _tmp56_ = NULL;
	GtkCheckButton* _tmp57_ = NULL;
	GtkCheckButton* _tmp58_ = NULL;
	GSettings* _tmp59_ = NULL;
	gboolean _tmp60_ = FALSE;
	GtkGrid* _tmp61_ = NULL;
	GtkCheckButton* _tmp62_ = NULL;
	gint _tmp63_ = 0;
	GtkGrid* _tmp64_ = NULL;
	const gchar* _tmp65_ = NULL;
	GtkLabel* _tmp66_ = NULL;
	GtkLabel* _tmp67_ = NULL;
	gint _tmp68_ = 0;
	const gchar* _tmp69_ = NULL;
	GtkFileChooserButton* _tmp70_ = NULL;
	GFile* destdir = NULL;
	GSettings* _tmp71_ = NULL;
	gchar* _tmp72_ = NULL;
	gchar* _tmp73_ = NULL;
	GFile* _tmp74_ = NULL;
	GFile* _tmp75_ = NULL;
	GFile* _tmp76_ = NULL;
	gboolean _tmp77_ = FALSE;
	GtkGrid* _tmp82_ = NULL;
	GtkFileChooserButton* _tmp83_ = NULL;
	gint _tmp84_ = 0;
	GtkGrid* _tmp85_ = NULL;
	const gchar* _tmp86_ = NULL;
	GtkLabel* _tmp87_ = NULL;
	GtkLabel* _tmp88_ = NULL;
	gint _tmp89_ = 0;
	GraniteWidgetsModeButton* _tmp90_ = NULL;
	GraniteWidgetsModeButton* _tmp91_ = NULL;
	GraniteWidgetsModeButton* _tmp92_ = NULL;
	GraniteWidgetsModeButton* _tmp93_ = NULL;
	GSettings* _tmp94_ = NULL;
	gchar* _tmp95_ = NULL;
	gchar* _tmp96_ = NULL;
	GQuark _tmp98_ = 0U;
	static GQuark _tmp97_label0 = 0;
	static GQuark _tmp97_label1 = 0;
	static GQuark _tmp97_label2 = 0;
	GtkGrid* _tmp102_ = NULL;
	GraniteWidgetsModeButton* _tmp103_ = NULL;
	gint _tmp104_ = 0;
	GError * _inner_error_ = NULL;
	g_return_if_fail (self != NULL);
	_tmp0_ = (GtkBox*) gtk_dialog_get_content_area ((GtkDialog*) self);
	_tmp1_ = _g_object_ref0 (_tmp0_);
	content_area = _tmp1_;
	_tmp2_ = (GtkGrid*) gtk_grid_new ();
	g_object_ref_sink (_tmp2_);
	grid = _tmp2_;
	_tmp3_ = grid;
	gtk_grid_set_row_spacing (_tmp3_, (guint) 10);
	_tmp4_ = grid;
	gtk_grid_set_column_spacing (_tmp4_, (guint) 10);
	_tmp5_ = content_area;
	_tmp6_ = grid;
	gtk_box_pack_start (_tmp5_, (GtkWidget*) _tmp6_, TRUE, TRUE, (guint) 0);
	_tmp7_ = _ ("Close");
	gtk_dialog_add_button ((GtkDialog*) self, _tmp7_, (gint) GTK_RESPONSE_CLOSE);
	row = 0;
	_tmp8_ = grid;
	_tmp9_ = _ ("Countdown");
	_tmp10_ = (GtkLabel*) gtk_label_new (_tmp9_);
	g_object_ref_sink (_tmp10_);
	_tmp11_ = _tmp10_;
	_tmp12_ = row;
	gtk_grid_attach (_tmp8_, (GtkWidget*) _tmp11_, 0, _tmp12_, 1, 1);
	_g_object_unref0 (_tmp11_);
	_tmp13_ = (GtkSpinButton*) gtk_spin_button_new_with_range ((gdouble) 0, (gdouble) 100, (gdouble) 1);
	g_object_ref_sink (_tmp13_);
	_g_object_unref0 (self->countdown_spin_button);
	self->countdown_spin_button = _tmp13_;
	_tmp14_ = self->countdown_spin_button;
	_tmp15_ = self->settings;
	_tmp16_ = g_settings_get_int (_tmp15_, "countdown");
	gtk_spin_button_set_value (_tmp14_, (gdouble) _tmp16_);
	_tmp17_ = grid;
	_tmp18_ = self->countdown_spin_button;
	_tmp19_ = row;
	row = _tmp19_ + 1;
	gtk_grid_attach (_tmp17_, (GtkWidget*) _tmp18_, 1, _tmp19_, 1, 1);
	_tmp20_ = grid;
	_tmp21_ = _ ("Framerate");
	_tmp22_ = (GtkLabel*) gtk_label_new (_tmp21_);
	g_object_ref_sink (_tmp22_);
	_tmp23_ = _tmp22_;
	_tmp24_ = row;
	gtk_grid_attach (_tmp20_, (GtkWidget*) _tmp23_, 0, _tmp24_, 1, 1);
	_g_object_unref0 (_tmp23_);
	_tmp25_ = (GtkSpinButton*) gtk_spin_button_new_with_range ((gdouble) 1, (gdouble) 30, (gdouble) 1);
	g_object_ref_sink (_tmp25_);
	_g_object_unref0 (self->framerate_spin_button);
	self->framerate_spin_button = _tmp25_;
	_tmp26_ = self->framerate_spin_button;
	_tmp27_ = self->settings;
	_tmp28_ = g_settings_get_int (_tmp27_, "framerate");
	gtk_spin_button_set_value (_tmp26_, (gdouble) _tmp28_);
	_tmp29_ = grid;
	_tmp30_ = self->framerate_spin_button;
	_tmp31_ = row;
	row = _tmp31_ + 1;
	gtk_grid_attach (_tmp29_, (GtkWidget*) _tmp30_, 1, _tmp31_, 1, 1);
	_tmp32_ = _ ("Include pointer");
	_tmp33_ = (GtkCheckButton*) gtk_check_button_new_with_label (_tmp32_);
	g_object_ref_sink (_tmp33_);
	_g_object_unref0 (self->include_pointer_checkbutton);
	self->include_pointer_checkbutton = _tmp33_;
	_tmp34_ = self->include_pointer_checkbutton;
	_tmp35_ = self->settings;
	_tmp36_ = g_settings_get_boolean (_tmp35_, "include-pointer");
	gtk_toggle_button_set_active ((GtkToggleButton*) _tmp34_, _tmp36_);
	_tmp37_ = grid;
	_tmp38_ = self->include_pointer_checkbutton;
	_tmp39_ = row;
	row = _tmp39_ + 1;
	gtk_grid_attach (_tmp37_, (GtkWidget*) _tmp38_, 1, _tmp39_, 1, 1);
	_tmp40_ = _ ("Auto save");
	_tmp41_ = (GtkCheckButton*) gtk_check_button_new_with_label (_tmp40_);
	g_object_ref_sink (_tmp41_);
	_g_object_unref0 (self->auto_save_checkbutton);
	self->auto_save_checkbutton = _tmp41_;
	_tmp42_ = self->auto_save_checkbutton;
	_tmp43_ = self->settings;
	_tmp44_ = g_settings_get_boolean (_tmp43_, "auto-save");
	gtk_toggle_button_set_active ((GtkToggleButton*) _tmp42_, _tmp44_);
	_tmp45_ = grid;
	_tmp46_ = self->auto_save_checkbutton;
	_tmp47_ = row;
	row = _tmp47_ + 1;
	gtk_grid_attach (_tmp45_, (GtkWidget*) _tmp46_, 1, _tmp47_, 1, 1);
	_tmp48_ = _ ("Show notifications");
	_tmp49_ = (GtkCheckButton*) gtk_check_button_new_with_label (_tmp48_);
	g_object_ref_sink (_tmp49_);
	_g_object_unref0 (self->show_notifications_checkbutton);
	self->show_notifications_checkbutton = _tmp49_;
	_tmp50_ = self->show_notifications_checkbutton;
	_tmp51_ = self->settings;
	_tmp52_ = g_settings_get_boolean (_tmp51_, "show-notifications");
	gtk_toggle_button_set_active ((GtkToggleButton*) _tmp50_, _tmp52_);
	_tmp53_ = grid;
	_tmp54_ = self->show_notifications_checkbutton;
	_tmp55_ = row;
	row = _tmp55_ + 1;
	gtk_grid_attach (_tmp53_, (GtkWidget*) _tmp54_, 1, _tmp55_, 1, 1);
	_tmp56_ = _ ("Copy to clipboard");
	_tmp57_ = (GtkCheckButton*) gtk_check_button_new_with_label (_tmp56_);
	g_object_ref_sink (_tmp57_);
	_g_object_unref0 (self->copy_to_clipboard_checkbutton);
	self->copy_to_clipboard_checkbutton = _tmp57_;
	_tmp58_ = self->copy_to_clipboard_checkbutton;
	_tmp59_ = self->settings;
	_tmp60_ = g_settings_get_boolean (_tmp59_, "copy-to-clipboard");
	gtk_toggle_button_set_active ((GtkToggleButton*) _tmp58_, _tmp60_);
	_tmp61_ = grid;
	_tmp62_ = self->copy_to_clipboard_checkbutton;
	_tmp63_ = row;
	row = _tmp63_ + 1;
	gtk_grid_attach (_tmp61_, (GtkWidget*) _tmp62_, 1, _tmp63_, 1, 1);
	_tmp64_ = grid;
	_tmp65_ = _ ("Destination");
	_tmp66_ = (GtkLabel*) gtk_label_new (_tmp65_);
	g_object_ref_sink (_tmp66_);
	_tmp67_ = _tmp66_;
	_tmp68_ = row;
	gtk_grid_attach (_tmp64_, (GtkWidget*) _tmp67_, 0, _tmp68_, 1, 1);
	_g_object_unref0 (_tmp67_);
	_tmp69_ = _ ("Destination");
	_tmp70_ = (GtkFileChooserButton*) gtk_file_chooser_button_new (_tmp69_, GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER);
	g_object_ref_sink (_tmp70_);
	_g_object_unref0 (self->destination_file_chooser_button);
	self->destination_file_chooser_button = _tmp70_;
	_tmp71_ = self->settings;
	_tmp72_ = g_settings_get_string (_tmp71_, "destination");
	_tmp73_ = _tmp72_;
	_tmp74_ = g_file_new_for_path (_tmp73_);
	_tmp75_ = _tmp74_;
	_g_free0 (_tmp73_);
	destdir = _tmp75_;
	_tmp76_ = destdir;
	_tmp77_ = g_file_query_exists (_tmp76_, NULL);
	if (_tmp77_) {
		{
			GtkFileChooserButton* _tmp78_ = NULL;
			GFile* _tmp79_ = NULL;
			_tmp78_ = self->destination_file_chooser_button;
			_tmp79_ = destdir;
			gtk_file_chooser_set_file ((GtkFileChooser*) _tmp78_, _tmp79_, &_inner_error_);
			if (G_UNLIKELY (_inner_error_ != NULL)) {
				goto __catch4_g_error;
			}
		}
		goto __finally4;
		__catch4_g_error:
		{
			GError* e = NULL;
			GError* _tmp80_ = NULL;
			const gchar* _tmp81_ = NULL;
			e = _inner_error_;
			_inner_error_ = NULL;
			_tmp80_ = e;
			_tmp81_ = _tmp80_->message;
			g_warning ("SettingsDialog.vala:88: Error: %s", _tmp81_);
			_g_error_free0 (e);
		}
		__finally4:
		if (G_UNLIKELY (_inner_error_ != NULL)) {
			_g_object_unref0 (destdir);
			_g_object_unref0 (grid);
			_g_object_unref0 (content_area);
			g_critical ("file %s: line %d: uncaught error: %s (%s, %d)", __FILE__, __LINE__, _inner_error_->message, g_quark_to_string (_inner_error_->domain), _inner_error_->code);
			g_clear_error (&_inner_error_);
			return;
		}
	}
	_tmp82_ = grid;
	_tmp83_ = self->destination_file_chooser_button;
	_tmp84_ = row;
	row = _tmp84_ + 1;
	gtk_grid_attach (_tmp82_, (GtkWidget*) _tmp83_, 1, _tmp84_, 1, 1);
	_tmp85_ = grid;
	_tmp86_ = _ ("File format");
	_tmp87_ = (GtkLabel*) gtk_label_new (_tmp86_);
	g_object_ref_sink (_tmp87_);
	_tmp88_ = _tmp87_;
	_tmp89_ = row;
	gtk_grid_attach (_tmp85_, (GtkWidget*) _tmp88_, 0, _tmp89_, 1, 1);
	_g_object_unref0 (_tmp88_);
	_tmp90_ = granite_widgets_mode_button_new ();
	g_object_ref_sink (_tmp90_);
	_g_object_unref0 (self->file_format_mode_button);
	self->file_format_mode_button = _tmp90_;
	_tmp91_ = self->file_format_mode_button;
	granite_widgets_mode_button_append_text (_tmp91_, "PNG");
	_tmp92_ = self->file_format_mode_button;
	granite_widgets_mode_button_append_text (_tmp92_, "JPG");
	_tmp93_ = self->file_format_mode_button;
	granite_widgets_mode_button_append_text (_tmp93_, "GIF");
	_tmp94_ = self->settings;
	_tmp95_ = g_settings_get_string (_tmp94_, "file-format");
	_tmp96_ = _tmp95_;
	_tmp98_ = (NULL == _tmp96_) ? 0 : g_quark_from_string (_tmp96_);
	g_free (_tmp96_);
	if (_tmp98_ == ((0 != _tmp97_label0) ? _tmp97_label0 : (_tmp97_label0 = g_quark_from_static_string ("png")))) {
		switch (0) {
			default:
			{
				GraniteWidgetsModeButton* _tmp99_ = NULL;
				_tmp99_ = self->file_format_mode_button;
				granite_widgets_mode_button_set_active (_tmp99_, 0);
				break;
			}
		}
	} else if (_tmp98_ == ((0 != _tmp97_label1) ? _tmp97_label1 : (_tmp97_label1 = g_quark_from_static_string ("jpg")))) {
		switch (0) {
			default:
			{
				GraniteWidgetsModeButton* _tmp100_ = NULL;
				_tmp100_ = self->file_format_mode_button;
				granite_widgets_mode_button_set_active (_tmp100_, 1);
				break;
			}
		}
	} else if (_tmp98_ == ((0 != _tmp97_label2) ? _tmp97_label2 : (_tmp97_label2 = g_quark_from_static_string ("gif")))) {
		switch (0) {
			default:
			{
				GraniteWidgetsModeButton* _tmp101_ = NULL;
				_tmp101_ = self->file_format_mode_button;
				granite_widgets_mode_button_set_active (_tmp101_, 2);
				break;
			}
		}
	}
	_tmp102_ = grid;
	_tmp103_ = self->file_format_mode_button;
	_tmp104_ = row;
	row = _tmp104_ + 1;
	gtk_grid_attach (_tmp102_, (GtkWidget*) _tmp103_, 1, _tmp104_, 1, 1);
	gtk_widget_show_all ((GtkWidget*) self);
	_g_object_unref0 (destdir);
	_g_object_unref0 (grid);
	_g_object_unref0 (content_area);
}


static void __lambda11_ (CaptureSettingsDialog* self) {
	GSettings* _tmp0_ = NULL;
	GtkSpinButton* _tmp1_ = NULL;
	gdouble _tmp2_ = 0.0;
	_tmp0_ = self->settings;
	_tmp1_ = self->countdown_spin_button;
	_tmp2_ = gtk_spin_button_get_value (_tmp1_);
	g_settings_set_int (_tmp0_, "countdown", (gint) _tmp2_);
}


static void ___lambda11__gtk_editable_changed (GtkEditable* _sender, gpointer self) {
	__lambda11_ ((CaptureSettingsDialog*) self);
}


static void __lambda12_ (CaptureSettingsDialog* self) {
	GSettings* _tmp0_ = NULL;
	GtkSpinButton* _tmp1_ = NULL;
	gdouble _tmp2_ = 0.0;
	_tmp0_ = self->settings;
	_tmp1_ = self->framerate_spin_button;
	_tmp2_ = gtk_spin_button_get_value (_tmp1_);
	g_settings_set_int (_tmp0_, "framerate", (gint) _tmp2_);
}


static void ___lambda12__gtk_editable_changed (GtkEditable* _sender, gpointer self) {
	__lambda12_ ((CaptureSettingsDialog*) self);
}


static void __lambda13_ (CaptureSettingsDialog* self) {
	GSettings* _tmp0_ = NULL;
	GtkCheckButton* _tmp1_ = NULL;
	gboolean _tmp2_ = FALSE;
	_tmp0_ = self->settings;
	_tmp1_ = self->include_pointer_checkbutton;
	_tmp2_ = gtk_toggle_button_get_active ((GtkToggleButton*) _tmp1_);
	g_settings_set_boolean (_tmp0_, "include-pointer", _tmp2_);
}


static void ___lambda13__gtk_toggle_button_toggled (GtkToggleButton* _sender, gpointer self) {
	__lambda13_ ((CaptureSettingsDialog*) self);
}


static void __lambda14_ (CaptureSettingsDialog* self) {
	GSettings* _tmp0_ = NULL;
	GtkCheckButton* _tmp1_ = NULL;
	gboolean _tmp2_ = FALSE;
	_tmp0_ = self->settings;
	_tmp1_ = self->auto_save_checkbutton;
	_tmp2_ = gtk_toggle_button_get_active ((GtkToggleButton*) _tmp1_);
	g_settings_set_boolean (_tmp0_, "auto-save", _tmp2_);
}


static void ___lambda14__gtk_toggle_button_toggled (GtkToggleButton* _sender, gpointer self) {
	__lambda14_ ((CaptureSettingsDialog*) self);
}


static gchar* string_to_utf8 (const gchar* self, int* result_length1) {
	gchar* result = NULL;
	gchar* _result_ = NULL;
	gint _tmp0_ = 0;
	gint _tmp1_ = 0;
	gchar* _tmp2_ = NULL;
	gint _result__length1 = 0;
	gint __result__size_ = 0;
	gint _tmp3_ = 0;
	gchar* _tmp4_ = NULL;
	gint _tmp4__length1 = 0;
	gint _tmp5_ = 0;
	gint _tmp6_ = 0;
	gchar* _tmp7_ = NULL;
	gint _tmp7__length1 = 0;
	g_return_val_if_fail (self != NULL, NULL);
	_tmp0_ = strlen (self);
	_tmp1_ = _tmp0_;
	_tmp2_ = g_new0 (gchar, _tmp1_ + 1);
	_result_ = _tmp2_;
	_result__length1 = _tmp1_ + 1;
	__result__size_ = _result__length1;
	_tmp3_ = _result__length1;
	_result__length1 = _tmp3_ - 1;
	_tmp4_ = _result_;
	_tmp4__length1 = _result__length1;
	_tmp5_ = strlen (self);
	_tmp6_ = _tmp5_;
	memcpy (_tmp4_, self, (gsize) _tmp6_);
	_tmp7_ = _result_;
	_tmp7__length1 = _result__length1;
	if (result_length1) {
		*result_length1 = _tmp7__length1;
	}
	result = _tmp7_;
	return result;
}


static void __lambda15_ (CaptureSettingsDialog* self) {
	gchar* filename = NULL;
	GtkFileChooserButton* _tmp0_ = NULL;
	gchar* _tmp1_ = NULL;
	gchar* _tmp2_ = NULL;
	gchar* _tmp3_ = NULL;
	GSettings* _tmp4_ = NULL;
	gint _tmp5_ = 0;
	gchar* _tmp6_ = NULL;
	gchar* _tmp7_ = NULL;
	_tmp0_ = self->destination_file_chooser_button;
	_tmp1_ = gtk_file_chooser_get_filename ((GtkFileChooser*) _tmp0_);
	filename = _tmp1_;
	_tmp2_ = g_strdup_printf ("filename=%s", filename);
	_tmp3_ = _tmp2_;
	plank_logger_notification (_tmp3_, "");
	_g_free0 (_tmp3_);
	_tmp4_ = self->settings;
	_tmp6_ = string_to_utf8 (filename, &_tmp5_);
	_tmp7_ = (gchar*) _tmp6_;
	g_settings_set_string (_tmp4_, "destination", _tmp7_);
	_g_free0 (_tmp7_);
	_g_free0 (filename);
}


static void ___lambda15__gtk_file_chooser_selection_changed (GtkFileChooser* _sender, gpointer self) {
	__lambda15_ ((CaptureSettingsDialog*) self);
}


static void __lambda16_ (CaptureSettingsDialog* self) {
	GSettings* _tmp0_ = NULL;
	GtkCheckButton* _tmp1_ = NULL;
	gboolean _tmp2_ = FALSE;
	_tmp0_ = self->settings;
	_tmp1_ = self->copy_to_clipboard_checkbutton;
	_tmp2_ = gtk_toggle_button_get_active ((GtkToggleButton*) _tmp1_);
	g_settings_set_boolean (_tmp0_, "copy-to-clipboard", _tmp2_);
}


static void ___lambda16__gtk_toggle_button_toggled (GtkToggleButton* _sender, gpointer self) {
	__lambda16_ ((CaptureSettingsDialog*) self);
}


static void __lambda17_ (CaptureSettingsDialog* self) {
	GSettings* _tmp0_ = NULL;
	GtkCheckButton* _tmp1_ = NULL;
	gboolean _tmp2_ = FALSE;
	_tmp0_ = self->settings;
	_tmp1_ = self->show_notifications_checkbutton;
	_tmp2_ = gtk_toggle_button_get_active ((GtkToggleButton*) _tmp1_);
	g_settings_set_boolean (_tmp0_, "show-notifications", _tmp2_);
}


static void ___lambda17__gtk_toggle_button_toggled (GtkToggleButton* _sender, gpointer self) {
	__lambda17_ ((CaptureSettingsDialog*) self);
}


static void __lambda18_ (CaptureSettingsDialog* self) {
	GraniteWidgetsModeButton* _tmp0_ = NULL;
	gint _tmp1_ = 0;
	gint _tmp2_ = 0;
	_tmp0_ = self->file_format_mode_button;
	_tmp1_ = granite_widgets_mode_button_get_selected (_tmp0_);
	_tmp2_ = _tmp1_;
	switch (_tmp2_) {
		case 0:
		{
			GSettings* _tmp3_ = NULL;
			_tmp3_ = self->settings;
			g_settings_set_string (_tmp3_, "file-format", "png");
			break;
		}
		case 1:
		{
			GSettings* _tmp4_ = NULL;
			_tmp4_ = self->settings;
			g_settings_set_string (_tmp4_, "file-format", "jpg");
			break;
		}
		case 2:
		{
			GSettings* _tmp5_ = NULL;
			_tmp5_ = self->settings;
			g_settings_set_string (_tmp5_, "file-format", "gif");
			break;
		}
		default:
		{
			GSettings* _tmp6_ = NULL;
			_tmp6_ = self->settings;
			g_settings_set_string (_tmp6_, "file-format", "png");
			break;
		}
	}
}


static void ___lambda18__granite_widgets_mode_button_mode_changed (GraniteWidgetsModeButton* _sender, GtkWidget* widget, gpointer self) {
	__lambda18_ ((CaptureSettingsDialog*) self);
}


static void capture_settings_dialog_connect_signals (CaptureSettingsDialog* self) {
	GtkSpinButton* _tmp0_ = NULL;
	GtkSpinButton* _tmp1_ = NULL;
	GtkCheckButton* _tmp2_ = NULL;
	GtkCheckButton* _tmp3_ = NULL;
	GtkFileChooserButton* _tmp4_ = NULL;
	GtkCheckButton* _tmp5_ = NULL;
	GtkCheckButton* _tmp6_ = NULL;
	GraniteWidgetsModeButton* _tmp7_ = NULL;
	g_return_if_fail (self != NULL);
	_tmp0_ = self->countdown_spin_button;
	g_signal_connect_object ((GtkEditable*) _tmp0_, "changed", (GCallback) ___lambda11__gtk_editable_changed, self, 0);
	_tmp1_ = self->framerate_spin_button;
	g_signal_connect_object ((GtkEditable*) _tmp1_, "changed", (GCallback) ___lambda12__gtk_editable_changed, self, 0);
	_tmp2_ = self->include_pointer_checkbutton;
	g_signal_connect_object ((GtkToggleButton*) _tmp2_, "toggled", (GCallback) ___lambda13__gtk_toggle_button_toggled, self, 0);
	_tmp3_ = self->auto_save_checkbutton;
	g_signal_connect_object ((GtkToggleButton*) _tmp3_, "toggled", (GCallback) ___lambda14__gtk_toggle_button_toggled, self, 0);
	_tmp4_ = self->destination_file_chooser_button;
	g_signal_connect_object ((GtkFileChooser*) _tmp4_, "selection-changed", (GCallback) ___lambda15__gtk_file_chooser_selection_changed, self, 0);
	_tmp5_ = self->copy_to_clipboard_checkbutton;
	g_signal_connect_object ((GtkToggleButton*) _tmp5_, "toggled", (GCallback) ___lambda16__gtk_toggle_button_toggled, self, 0);
	_tmp6_ = self->show_notifications_checkbutton;
	g_signal_connect_object ((GtkToggleButton*) _tmp6_, "toggled", (GCallback) ___lambda17__gtk_toggle_button_toggled, self, 0);
	_tmp7_ = self->file_format_mode_button;
	g_signal_connect_object (_tmp7_, "mode-changed", (GCallback) ___lambda18__granite_widgets_mode_button_mode_changed, self, 0);
}


static GObject * capture_settings_dialog_constructor (GType type, guint n_construct_properties, GObjectConstructParam * construct_properties) {
	GObject * obj;
	GObjectClass * parent_class;
	CaptureSettingsDialog * self;
	parent_class = G_OBJECT_CLASS (capture_settings_dialog_parent_class);
	obj = parent_class->constructor (type, n_construct_properties, construct_properties);
	self = G_TYPE_CHECK_INSTANCE_CAST (obj, CAPTURE_TYPE_SETTINGS_DIALOG, CaptureSettingsDialog);
	setlocale (LC_MESSAGES, "");
	textdomain (GETTEXT_PACKAGE);
	bind_textdomain_codeset (GETTEXT_PACKAGE, "utf-8");
	bindtextdomain (GETTEXT_PACKAGE, "./po");
	return obj;
}


static void capture_settings_dialog_class_init (CaptureSettingsDialogClass * klass) {
	capture_settings_dialog_parent_class = g_type_class_peek_parent (klass);
	G_OBJECT_CLASS (klass)->constructor = capture_settings_dialog_constructor;
	G_OBJECT_CLASS (klass)->finalize = capture_settings_dialog_finalize;
}


static void capture_settings_dialog_instance_init (CaptureSettingsDialog * self) {
}


static void capture_settings_dialog_finalize (GObject* obj) {
	CaptureSettingsDialog * self;
	self = G_TYPE_CHECK_INSTANCE_CAST (obj, CAPTURE_TYPE_SETTINGS_DIALOG, CaptureSettingsDialog);
	_g_object_unref0 (self->settings);
	_g_object_unref0 (self->countdown_spin_button);
	_g_object_unref0 (self->framerate_spin_button);
	_g_object_unref0 (self->include_pointer_checkbutton);
	_g_object_unref0 (self->auto_save_checkbutton);
	_g_object_unref0 (self->show_notifications_checkbutton);
	_g_object_unref0 (self->copy_to_clipboard_checkbutton);
	_g_object_unref0 (self->destination_file_chooser_button);
	_g_object_unref0 (self->file_format_mode_button);
	G_OBJECT_CLASS (capture_settings_dialog_parent_class)->finalize (obj);
}


GType capture_settings_dialog_get_type (void) {
	static volatile gsize capture_settings_dialog_type_id__volatile = 0;
	if (g_once_init_enter (&capture_settings_dialog_type_id__volatile)) {
		static const GTypeInfo g_define_type_info = { sizeof (CaptureSettingsDialogClass), (GBaseInitFunc) NULL, (GBaseFinalizeFunc) NULL, (GClassInitFunc) capture_settings_dialog_class_init, (GClassFinalizeFunc) NULL, NULL, sizeof (CaptureSettingsDialog), 0, (GInstanceInitFunc) capture_settings_dialog_instance_init, NULL };
		GType capture_settings_dialog_type_id;
		capture_settings_dialog_type_id = g_type_register_static (gtk_dialog_get_type (), "CaptureSettingsDialog", &g_define_type_info, 0);
		g_once_init_leave (&capture_settings_dialog_type_id__volatile, capture_settings_dialog_type_id);
	}
	return capture_settings_dialog_type_id__volatile;
}


