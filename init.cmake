######################################
### Fmod support
######################################

if(EZ_CMAKE_PLATFORM_WINDOWS)
  set (EZ_BUILD_FMOD ON CACHE BOOL "Whether support for FMOD should be added")
else()
  set (EZ_BUILD_FMOD OFF CACHE BOOL "Whether support for FMOD should be added" FORCE)
endif()


set (EZ_FMOD_USE_CUSTOM_INSTALLATION OFF CACHE BOOL "If enabled, the built-in FMOD version is ignored and any installed version is used instead. Clear EZ_FMOD_SDK_LOCATION to let CMake reevaluate the path.")

mark_as_advanced(FORCE EZ_FMOD_USE_CUSTOM_INSTALLATION)

######################################
### ez_requires_fmod()
######################################

macro(ez_requires_fmod)

	ez_requires_windows()
	ez_requires(EZ_BUILD_FMOD)

endmacro()

######################################
### ez_link_target_fmod(<target>)
######################################

function(ez_link_target_fmod TARGET_NAME)

	ez_requires_fmod()

    target_link_libraries(${TARGET_NAME} PRIVATE ezFmod::Studio)

    add_custom_command(TARGET ${TARGET_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different $<TARGET_FILE:ezFmod::Studio> $<TARGET_FILE_DIR:${TARGET_NAME}>
        COMMAND ${CMAKE_COMMAND} -E copy_if_different $<TARGET_FILE:ezFmod::Core> $<TARGET_FILE_DIR:${TARGET_NAME}>
  )

endfunction()

