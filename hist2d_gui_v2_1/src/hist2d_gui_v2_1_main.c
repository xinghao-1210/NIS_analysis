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

#include <stdio.h>
#include "mclmcrrt.h"
#ifdef __cplusplus
extern "C" {
#endif

extern mclComponentData __MCC_hist2d_gui_v2_1_component_data;

#ifdef __cplusplus
}
#endif

static HMCRINSTANCE _mcr_inst = NULL;


#ifdef __cplusplus
extern "C" {
#endif

static int mclDefaultPrintHandler(const char *s)
{
  return mclWrite(1 /* stdout */, s, sizeof(char)*strlen(s));
}

#ifdef __cplusplus
} /* End extern "C" block */
#endif

#ifdef __cplusplus
extern "C" {
#endif

static int mclDefaultErrorHandler(const char *s)
{
  int written = 0;
  size_t len = 0;
  len = strlen(s);
  written = mclWrite(2 /* stderr */, s, sizeof(char)*len);
  if (len > 0 && s[ len-1 ] != '\n')
    written += mclWrite(2 /* stderr */, "\n", sizeof(char));
  return written;
}

#ifdef __cplusplus
} /* End extern "C" block */
#endif

/* This symbol is defined in shared libraries. Define it here
 * (to nothing) in case this isn't a shared library. 
 */
#ifndef LIB_hist2d_gui_v2_1_C_API 
#define LIB_hist2d_gui_v2_1_C_API /* No special import/export declaration */
#endif

LIB_hist2d_gui_v2_1_C_API 
bool MW_CALL_CONV hist2d_gui_v2_1InitializeWithHandlers(
    mclOutputHandlerFcn error_handler,
    mclOutputHandlerFcn print_handler
)
{
  if (_mcr_inst != NULL)
    return true;
  if (!mclmcrInitialize())
    return false;
  if (!mclInitializeComponentInstanceWithEmbeddedCTF(&_mcr_inst,
                                                     &__MCC_hist2d_gui_v2_1_component_data,
                                                     true, NoObjectType,
                                                     ExeTarget, error_handler,
                                                     print_handler, 134043, NULL))
    return false;
  return true;
}

LIB_hist2d_gui_v2_1_C_API 
bool MW_CALL_CONV hist2d_gui_v2_1Initialize(void)
{
  return hist2d_gui_v2_1InitializeWithHandlers(mclDefaultErrorHandler,
                                               mclDefaultPrintHandler);
}

LIB_hist2d_gui_v2_1_C_API 
void MW_CALL_CONV hist2d_gui_v2_1Terminate(void)
{
  if (_mcr_inst != NULL)
    mclTerminateInstance(&_mcr_inst);
}

int run_main(int argc, const char **argv)
{
  int _retval;
  /* Generate and populate the path_to_component. */
  char path_to_component[(PATH_MAX*2)+1];
  separatePathName(argv[0], path_to_component, (PATH_MAX*2)+1);
  __MCC_hist2d_gui_v2_1_component_data.path_to_component = path_to_component; 
  if (!hist2d_gui_v2_1Initialize()) {
    return -1;
  }
  argc = mclSetCmdLineUserData(mclGetID(_mcr_inst), argc, argv);
  _retval = mclMain(_mcr_inst, argc, argv, "hist2d_gui", 1);
  if (_retval == 0 /* no error */) mclWaitForFiguresToDie(NULL);
  hist2d_gui_v2_1Terminate();
  mclTerminateApplication();
  return _retval;
}

int main(int argc, const char **argv)
{
  if (!mclInitializeApplication(
    __MCC_hist2d_gui_v2_1_component_data.runtime_options,
    __MCC_hist2d_gui_v2_1_component_data.runtime_option_count))
    return 0;
  
  return mclRunMain(run_main, argc, argv);
}
