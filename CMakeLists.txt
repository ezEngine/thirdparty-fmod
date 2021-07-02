ez_cmake_init()

ez_requires_fmod()

if (CMAKE_SYSTEM_NAME STREQUAL "WindowsStore")
	# UWP builds

	find_path(EZ_FMOD_DIR api/core/inc/fmod.h
		PATHS
		[HKEY_CURRENT_USER\\Software\\FMOD\ Studio\ API\ Universal\ Windows\ Platform]
		${CMAKE_SOURCE_DIR}/Code/ThirdParty/fmod/windows-uwp
		)
		
	set(FMOD_DLL_SUFFIX ".dll")
	set(FMOD_LIB_SUFFIX ".lib")
		
else()
	# Desktop Windows builds
		
	find_path(EZ_FMOD_DIR api/core/inc/fmod.h
		PATHS
		[HKEY_CURRENT_USER\\Software\\FMOD\ Studio\ API\ Windows]
		${CMAKE_SOURCE_DIR}/Code/ThirdParty/fmod/windows
	)

	set(FMOD_DLL_SUFFIX ".dll")
	set(FMOD_LIB_SUFFIX "_vc.lib")

endif()

set (FMOD_DIR_STUDIO "${EZ_FMOD_DIR}/api/studio")
set (FMOD_DIR_FSBANK "${EZ_FMOD_DIR}/api/fsbank")
set (FMOD_DIR_CORE "${EZ_FMOD_DIR}/api/core")

if (EZ_CMAKE_ARCHITECTURE_ARM)
	if(CMAKE_SIZEOF_VOID_P EQUAL 8)
		message(FATAL_ERROR "Fmod does not support arm64, or support needs to be added to EZ once binaries become available")
	else()
		set(FMOD_LIB_ARCH "arm")
	endif()
else()
	if(CMAKE_SIZEOF_VOID_P EQUAL 8)
		set(FMOD_LIB_ARCH "x64")
	else()
		set(FMOD_LIB_ARCH "x86")
	endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(EzFmod DEFAULT_MSG EZ_FMOD_DIR)

if (EZFMOD_FOUND)

	set(FMOD_DEBUG_SUFFIX, "")
	
	# set this, if you want the 'logging' libraries
	#set(FMOD_DEBUG_SUFFIX, "L")

	add_library(ezFmod::Core SHARED IMPORTED GLOBAL)
	set_target_properties(ezFmod::Core PROPERTIES IMPORTED_LOCATION "${FMOD_DIR_CORE}/lib/${FMOD_LIB_ARCH}/fmod${FMOD_DLL_SUFFIX}")
	set_target_properties(ezFmod::Core PROPERTIES IMPORTED_LOCATION_DEBUG "${FMOD_DIR_CORE}/lib/${FMOD_LIB_ARCH}/fmod${FMOD_DEBUG_SUFFIX}${FMOD_DLL_SUFFIX}")
	set_target_properties(ezFmod::Core PROPERTIES IMPORTED_IMPLIB "${FMOD_DIR_CORE}/lib/${FMOD_LIB_ARCH}/fmod${FMOD_LIB_SUFFIX}")
	set_target_properties(ezFmod::Core PROPERTIES IMPORTED_IMPLIB_DEBUG "${FMOD_DIR_CORE}/lib/${FMOD_LIB_ARCH}/fmod${FMOD_DEBUG_SUFFIX}${FMOD_LIB_SUFFIX}")
	set_target_properties(ezFmod::Core PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${FMOD_DIR_CORE}/inc")
	ez_uwp_mark_import_as_content(ezFmod::Core)

	add_library(ezFmod::FsBank SHARED IMPORTED GLOBAL)
	set_target_properties(ezFmod::FsBank PROPERTIES IMPORTED_LOCATION "${FMOD_DIR_FSBANK}/lib/${FMOD_LIB_ARCH}/fsbank${FMOD_DLL_SUFFIX}")
	set_target_properties(ezFmod::FsBank PROPERTIES IMPORTED_LOCATION_DEBUG "${FMOD_DIR_FSBANK}/lib/${FMOD_LIB_ARCH}/fsbank${FMOD_DEBUG_SUFFIX}${FMOD_DLL_SUFFIX}")
	set_target_properties(ezFmod::FsBank PROPERTIES IMPORTED_IMPLIB "${FMOD_DIR_FSBANK}/lib/${FMOD_LIB_ARCH}/fsbank${FMOD_LIB_SUFFIX}")
	set_target_properties(ezFmod::FsBank PROPERTIES IMPORTED_IMPLIB_DEBUG "${FMOD_DIR_FSBANK}/lib/${FMOD_LIB_ARCH}/fsbank${FMOD_DEBUG_SUFFIX}${FMOD_LIB_SUFFIX}")
	set_target_properties(ezFmod::FsBank PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${FMOD_DIR_FSBANK}/inc")
	ez_uwp_mark_import_as_content(ezFmod::FsBank)

	add_library(ezFmod::Studio SHARED IMPORTED GLOBAL)
	set_target_properties(ezFmod::Studio PROPERTIES IMPORTED_LOCATION "${FMOD_DIR_STUDIO}/lib/${FMOD_LIB_ARCH}/fmodstudio${FMOD_DLL_SUFFIX}")
	set_target_properties(ezFmod::Studio PROPERTIES IMPORTED_LOCATION_DEBUG "${FMOD_DIR_STUDIO}/lib/${FMOD_LIB_ARCH}/fmodstudio${FMOD_DEBUG_SUFFIX}${FMOD_DLL_SUFFIX}")
	set_target_properties(ezFmod::Studio PROPERTIES IMPORTED_IMPLIB "${FMOD_DIR_STUDIO}/lib/${FMOD_LIB_ARCH}/fmodstudio${FMOD_LIB_SUFFIX}")
	set_target_properties(ezFmod::Studio PROPERTIES IMPORTED_IMPLIB_DEBUG "${FMOD_DIR_STUDIO}/lib/${FMOD_LIB_ARCH}/fmodstudio${FMOD_DEBUG_SUFFIX}${FMOD_LIB_SUFFIX}")
	set_target_properties(ezFmod::Studio PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${FMOD_DIR_STUDIO}/inc")
	target_link_libraries(ezFmod::Studio INTERFACE ezFmod::Core)
	ez_uwp_mark_import_as_content(ezFmod::Studio)

endif()

mark_as_advanced(FORCE EZ_FMOD_DIR)