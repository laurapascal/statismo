message( "External project - VTK" )

find_package(Git)
if(NOT GIT_FOUND)
  message(ERROR "Cannot find git. git is required for Superbuild")
endif()

option( USE_GIT_PROTOCOL "If behind a firewall turn this off to use http instead." ON)

set(git_protocol "git")
if(NOT USE_GIT_PROTOCOL)
  set(git_protocol "http")
endif()

set( VTK_DEPENDENCIES )

if( ${USE_SYSTEM_HDF5} MATCHES "OFF" )
  set( VTK_DEPENDENCIES HDF5 )
endif()

set( _vtkOptions )
if( APPLE )
  set( _vtkOptions -DVTK_REQUIRED_OBJCXX_FLAGS:STRING="" )
endif()

set(Slicer_VTK_RENDERING_BACKEND "OpenGL")

ExternalProject_Add(VTK
  DEPENDS ${VTK_DEPENDENCIES}
  GIT_REPOSITORY ${git_protocol}://vtk.org/VTK.git
  GIT_TAG v6.3.0
  SOURCE_DIR VTK
  BINARY_DIR VTK-build
  UPDATE_COMMAND ""
  PATCH_COMMAND ""
  CMAKE_GENERATOR ${EP_CMAKE_GENERATOR}
  CMAKE_ARGS
    ${ep_common_args}
    ${_vtkOptions}
  	${cmake_hdf5_libs}
    -DBUILD_EXAMPLES:BOOL=OFF
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DBUILD_TESTING:BOOL=OFF
    -DCMAKE_BUILD_TYPE:STRING=${BUILD_TYPE}
    -DVTK_BUILD_ALL_MODULES:BOOL=OFF
    -DVTK_USE_SYSTEM_HDF5:BOOL=ON
    -DHDF5_DIR:PATH=${HDF5_DIR}
    -DModule_vtkGUISupportQtOpenGL:BOOL=ON
    -DModule_vtkGUISupportQtWebkit:BOOL=ON
    -DModule_vtkGUISupportQtSQL:BOOL=ON
    -DModule_vtkRenderingQt:BOOL=ON
    -DVTK_USE_QVTK_QTOPENGL:BOOL=ON
    -DModule_vtkTestingRendering:BOOL=ON
    -DModule_vtkViewsQt:BOOL=ON
    -DVTK_WRAP_PYTHON:BOOL=ON
    -DModule_vtkWrappingPythonCore:BOOL=ON
    -DVTK_RENDERING_BACKEND:STRING=${Slicer_VTK_RENDERING_BACKEND}
    -DCMAKE_INSTALL_PREFIX:PATH=${INSTALL_DEPENDENCIES_DIR}
    -DCMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
    -DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
)

set( VTK_DIR ${INSTALL_DEPENDENCIES_DIR}/lib/cmake/vtk-6.3/ )
