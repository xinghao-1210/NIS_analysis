/*
 * MATLAB Compiler: 4.9 (R2008b)
 * Date: Mon Apr 03 19:07:22 2017
 * Arguments: "-B" "macro_default" "-o" "hist2d_gui_v2_2" "-W" "main" "-d"
 * "D:\Stephen\Programming\matlab\NIS_analysis\hist2d_gui_v2_2\src" "-T"
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
const unsigned char __MCC_hist2d_gui_v2_2_session_key[] = {
    'B', 'A', '3', 'D', '4', 'C', 'B', 'B', '6', 'F', '6', 'F', '1', '8', '3',
    '5', '0', '7', 'C', '7', 'E', 'A', 'D', '3', 'A', 'E', '6', 'C', '8', 'D',
    '6', 'C', 'C', 'F', '2', '5', '5', '4', '3', '9', 'A', '0', '3', 'F', 'C',
    'D', '3', '7', '7', '5', '3', 'A', 'B', '1', '8', '9', 'E', '7', '4', 'F',
    'E', '2', 'E', '1', 'A', '8', '4', '9', '1', '2', '7', '6', '2', 'F', 'A',
    'C', '7', '4', 'B', '5', '2', 'B', 'A', '4', 'E', '7', '3', '6', '9', '6',
    '9', '7', '3', '1', '9', 'D', '8', '6', '3', '8', '5', '9', '9', 'E', 'E',
    '9', '9', 'D', '0', '9', '8', '7', '4', 'B', '0', 'F', '7', '9', '3', '9',
    'D', '4', '1', '9', '6', '9', '8', 'E', '3', '8', '9', '4', '9', '5', '0',
    '8', '8', 'A', '7', 'B', '9', 'C', '3', '5', '2', '9', '9', '2', '8', '3',
    '7', '5', '8', '5', '6', '5', 'B', 'E', 'E', '3', 'F', '3', 'E', '8', '4',
    'B', 'C', '2', 'D', 'A', 'D', 'C', '9', 'E', '1', 'D', '3', '5', '9', '6',
    '5', 'A', '6', '7', '0', '6', '2', 'A', '6', '2', '3', '5', '4', 'A', 'B',
    'C', '5', 'B', '3', '9', '4', 'A', 'E', '4', '7', '4', 'B', '9', '3', '1',
    'F', 'F', 'B', '1', '3', 'E', 'B', 'E', 'F', 'C', '6', '6', '2', 'A', '2',
    'D', '1', 'F', '9', '5', '8', '0', '4', 'A', 'A', '8', '5', '4', 'F', 'E',
    'D', '1', '7', 'D', '6', 'D', '7', '5', '7', '1', '4', '7', '3', '6', '0',
    '1', '\0'};

const unsigned char __MCC_hist2d_gui_v2_2_public_key[] = {
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

static const char * MCC_hist2d_gui_v2_2_matlabpath_data[] = 
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

static const char * MCC_hist2d_gui_v2_2_classpath_data[] = 
  { "" };

static const char * MCC_hist2d_gui_v2_2_libpath_data[] = 
  { "" };

static const char * MCC_hist2d_gui_v2_2_app_opts_data[] = 
  { "" };

static const char * MCC_hist2d_gui_v2_2_run_opts_data[] = 
  { "" };

static const char * MCC_hist2d_gui_v2_2_warning_state_data[] = 
  { "off:MATLAB:dispatcher:nameConflict" };


mclComponentData __MCC_hist2d_gui_v2_2_component_data = { 

  /* Public key data */
  __MCC_hist2d_gui_v2_2_public_key,

  /* Component name */
  "hist2d_gui_v2_2",

  /* Component Root */
  "",

  /* Application key data */
  __MCC_hist2d_gui_v2_2_session_key,

  /* Component's MATLAB Path */
  MCC_hist2d_gui_v2_2_matlabpath_data,

  /* Number of directories in the MATLAB Path */
  42,

  /* Component's Java class path */
  MCC_hist2d_gui_v2_2_classpath_data,
  /* Number of directories in the Java class path */
  0,

  /* Component's load library path (for extra shared libraries) */
  MCC_hist2d_gui_v2_2_libpath_data,
  /* Number of directories in the load library path */
  0,

  /* MCR instance-specific runtime options */
  MCC_hist2d_gui_v2_2_app_opts_data,
  /* Number of MCR instance-specific runtime options */
  0,

  /* MCR global runtime options */
  MCC_hist2d_gui_v2_2_run_opts_data,
  /* Number of MCR global runtime options */
  0,
  
  /* Component preferences directory */
  "hist2d_gui_v_02F7AA151B9B64254AF84F6BA049B597",

  /* MCR warning status data */
  MCC_hist2d_gui_v2_2_warning_state_data,
  /* Number of MCR warning status modifiers */
  1,

  /* Path to component - evaluated at runtime */
  NULL

};

#ifdef __cplusplus
}
#endif


