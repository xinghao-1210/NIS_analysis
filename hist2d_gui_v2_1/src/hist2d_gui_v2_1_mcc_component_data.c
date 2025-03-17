/*
 * MATLAB Compiler: 4.9 (R2008b)
 * Date: Sun Dec 06 21:30:58 2015
 * Arguments: "-B" "macro_default" "-o" "hist2d_gui_v2_1" "-W" "main" "-d"
 * "D:\Stephen\Programming\matlab\NIS_analysis\hist2d_gui_v2_1\src" "-T"
 * "link:exe" "-v" "D:\Stephen\Programming\matlab\NIS_analysis\hist2d_gui.m"
 * "-a" "D:\Stephen\Programming\matlab\NIS_analysis\hist2d_gui.fig" "-a"
 * "D:\Stephen\Programming\matlab\NIS_analysis\hist1d_4gui_NIS_objdata.m" "-a"
 * "D:\Stephen\Programming\matlab\NIS_analysis\hist2d_4gui_NIS_objdata.m" "-a"
 * "D:\Stephen\Programming\matlab\NIS_analysis\read_NIS_objdata.m" "-a"
 * "d:\stephen\programming\matlab\search4excel_files_in_dir.m" "-a"
 * "D:\Stephen\Programming\matlab\NIS_analysis\dscatter_sltfix.m" "-a"
 * "d:\stephen\programming\matlab\qpcr_data\barwitherr.m" 
 */

#include "mclmcrrt.h"

#ifdef __cplusplus
extern "C" {
#endif
const unsigned char __MCC_hist2d_gui_v2_1_session_key[] = {
    '8', 'F', 'F', '3', 'C', 'D', '9', 'F', 'B', 'C', 'F', 'A', '0', 'B', 'F',
    'B', '2', '6', '9', 'D', '4', '3', 'F', '3', '8', '6', '3', '4', '7', '5',
    'D', '0', 'C', '5', '7', '3', 'D', '1', '0', '5', '8', '2', '7', '6', 'F',
    'A', '5', '2', '4', '3', '3', 'E', 'B', '8', '5', '8', 'A', '7', '8', '9',
    'D', '8', '5', 'D', 'C', '5', 'F', '9', '0', 'E', '2', '2', 'B', 'A', 'E',
    '6', '0', 'B', '5', 'D', '3', '3', '2', '8', '8', 'D', '4', 'B', '2', 'B',
    '7', '5', '9', 'A', 'D', 'E', 'F', '0', '7', 'F', 'E', 'F', '6', '2', 'A',
    'A', 'E', '3', '4', 'E', '2', 'F', '5', '7', '9', 'D', 'C', '0', '2', '6',
    '3', '8', '9', 'B', '2', 'F', 'D', 'D', '6', 'E', '2', 'C', '8', '6', '5',
    '4', 'D', 'D', 'C', '4', '7', 'A', '4', 'B', 'B', '2', 'F', '0', '8', 'A',
    '9', '0', '4', '1', '3', '7', '3', 'D', '9', 'B', '8', 'A', '3', 'F', '5',
    '3', '7', 'F', '6', 'C', '3', 'A', '5', '8', 'A', '1', '7', 'B', '2', '1',
    '3', '6', '3', 'B', 'B', 'D', 'A', 'A', 'C', '5', '9', 'C', '6', '0', '8',
    '2', 'C', '4', 'B', 'C', 'A', 'E', '5', '4', 'E', '4', 'E', '9', 'A', '1',
    '5', 'A', '9', '4', '2', '3', '9', '7', 'C', 'C', '6', 'B', 'F', '9', 'E',
    'C', '0', '7', 'A', '7', '7', '0', '3', 'E', 'D', 'A', 'C', '8', '9', 'E',
    'C', '9', '5', '2', '2', '0', '2', 'C', '8', 'F', '0', '8', 'B', 'E', '2',
    '1', '\0'};

const unsigned char __MCC_hist2d_gui_v2_1_public_key[] = {
    '3', '0', '8', '1', '9', 'D', '3', '0', '0', 'D', '0', '6', '0', '9', '2',
    'A', '8', '6', '4', '8', '8', '6', 'F', '7', '0', 'D', '0', '1', '0', '1',
    '0', '1', '0', '5', '0', '0', '0', '3', '8', '1', '8', 'B', '0', '0', '3',
    '0', '8', '1', '8', '7', '0', '2', '8', '1', '8', '1', '0', '0', 'C', '4',
    '9', 'C', 'A', 'C', '3', '4', 'E', 'D', '1', '3', 'A', '5', '2', '0', '6',
    '5', '8', 'F', '6', 'F', '8', 'E', '0', '1', '3', '8', 'C', '4', '3', '1',
    '5', 'B', '4', '3', '1', '5', '2', '7', '7', 'E', 'D', '3', 'F', '7', 'D',
    'A', 'E', '5', '3', '0', '9', '9', 'D', 'B', '0', '8', 'E', 'E', '5', '8',
    '9', 'F', '8', '0', '4', 'D', '4', 'B', '9', '8', '1', '3', '2', '6', 'A',
    '5', '2', 'C', 'C', 'E', '4', '3', '8', '2', 'E', '9', 'F', '2', 'B', '4',
    'D', '0', '8', '5', 'E', 'B', '9', '5', '0', 'C', '7', 'A', 'B', '1', '2',
    'E', 'D', 'E', '2', 'D', '4', '1', '2', '9', '7', '8', '2', '0', 'E', '6',
    '3', '7', '7', 'A', '5', 'F', 'E', 'B', '5', '6', '8', '9', 'D', '4', 'E',
    '6', '0', '3', '2', 'F', '6', '0', 'C', '4', '3', '0', '7', '4', 'A', '0',
    '4', 'C', '2', '6', 'A', 'B', '7', '2', 'F', '5', '4', 'B', '5', '1', 'B',
    'B', '4', '6', '0', '5', '7', '8', '7', '8', '5', 'B', '1', '9', '9', '0',
    '1', '4', '3', '1', '4', 'A', '6', '5', 'F', '0', '9', '0', 'B', '6', '1',
    'F', 'C', '2', '0', '1', '6', '9', '4', '5', '3', 'B', '5', '8', 'F', 'C',
    '8', 'B', 'A', '4', '3', 'E', '6', '7', '7', '6', 'E', 'B', '7', 'E', 'C',
    'D', '3', '1', '7', '8', 'B', '5', '6', 'A', 'B', '0', 'F', 'A', '0', '6',
    'D', 'D', '6', '4', '9', '6', '7', 'C', 'B', '1', '4', '9', 'E', '5', '0',
    '2', '0', '1', '1', '1', '\0'};

static const char * MCC_hist2d_gui_v2_1_matlabpath_data[] = 
  { "hist2d_gui_v/", "$TOOLBOXDEPLOYDIR/", "stephen/programming/matlab/",
    "stephen/programming/matlab/qpcr_data/", "$TOOLBOXMATLABDIR/general/",
    "$TOOLBOXMATLABDIR/ops/", "$TOOLBOXMATLABDIR/lang/",
    "$TOOLBOXMATLABDIR/elmat/", "$TOOLBOXMATLABDIR/randfun/",
    "$TOOLBOXMATLABDIR/elfun/", "$TOOLBOXMATLABDIR/specfun/",
    "$TOOLBOXMATLABDIR/matfun/", "$TOOLBOXMATLABDIR/datafun/",
    "$TOOLBOXMATLABDIR/polyfun/", "$TOOLBOXMATLABDIR/funfun/",
    "$TOOLBOXMATLABDIR/sparfun/", "$TOOLBOXMATLABDIR/scribe/",
    "$TOOLBOXMATLABDIR/graph2d/", "$TOOLBOXMATLABDIR/graph3d/",
    "$TOOLBOXMATLABDIR/specgraph/", "$TOOLBOXMATLABDIR/graphics/",
    "$TOOLBOXMATLABDIR/uitools/", "$TOOLBOXMATLABDIR/strfun/",
    "$TOOLBOXMATLABDIR/imagesci/", "$TOOLBOXMATLABDIR/iofun/",
    "$TOOLBOXMATLABDIR/audiovideo/", "$TOOLBOXMATLABDIR/timefun/",
    "$TOOLBOXMATLABDIR/datatypes/", "$TOOLBOXMATLABDIR/verctrl/",
    "$TOOLBOXMATLABDIR/codetools/", "$TOOLBOXMATLABDIR/helptools/",
    "$TOOLBOXMATLABDIR/winfun/", "$TOOLBOXMATLABDIR/demos/",
    "$TOOLBOXMATLABDIR/timeseries/", "$TOOLBOXMATLABDIR/hds/",
    "$TOOLBOXMATLABDIR/guide/", "$TOOLBOXMATLABDIR/plottools/",
    "toolbox/local/", "toolbox/shared/dastudio/",
    "$TOOLBOXMATLABDIR/datamanager/", "toolbox/compiler/", "toolbox/stats/" };

static const char * MCC_hist2d_gui_v2_1_classpath_data[] = 
  { "" };

static const char * MCC_hist2d_gui_v2_1_libpath_data[] = 
  { "" };

static const char * MCC_hist2d_gui_v2_1_app_opts_data[] = 
  { "" };

static const char * MCC_hist2d_gui_v2_1_run_opts_data[] = 
  { "" };

static const char * MCC_hist2d_gui_v2_1_warning_state_data[] = 
  { "off:MATLAB:dispatcher:nameConflict" };


mclComponentData __MCC_hist2d_gui_v2_1_component_data = { 

  /* Public key data */
  __MCC_hist2d_gui_v2_1_public_key,

  /* Component name */
  "hist2d_gui_v2_1",

  /* Component Root */
  "",

  /* Application key data */
  __MCC_hist2d_gui_v2_1_session_key,

  /* Component's MATLAB Path */
  MCC_hist2d_gui_v2_1_matlabpath_data,

  /* Number of directories in the MATLAB Path */
  42,

  /* Component's Java class path */
  MCC_hist2d_gui_v2_1_classpath_data,
  /* Number of directories in the Java class path */
  0,

  /* Component's load library path (for extra shared libraries) */
  MCC_hist2d_gui_v2_1_libpath_data,
  /* Number of directories in the load library path */
  0,

  /* MCR instance-specific runtime options */
  MCC_hist2d_gui_v2_1_app_opts_data,
  /* Number of MCR instance-specific runtime options */
  0,

  /* MCR global runtime options */
  MCC_hist2d_gui_v2_1_run_opts_data,
  /* Number of MCR global runtime options */
  0,
  
  /* Component preferences directory */
  "hist2d_gui_v_13EB4B89437ED3015F6592E554F0A290",

  /* MCR warning status data */
  MCC_hist2d_gui_v2_1_warning_state_data,
  /* Number of MCR warning status modifiers */
  1,

  /* Path to component - evaluated at runtime */
  NULL

};

#ifdef __cplusplus
}
#endif


