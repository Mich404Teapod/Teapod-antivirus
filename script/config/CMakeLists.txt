
add_executable(configsig
	config.cmake
)

target_compile_features(configsig PUBLIC cxx_std_17)

target_link_libraries(getsig
	teapod::fileformat
)

set_target_properties(configsig
	PROPERTIES
		OUTPUT_NAME "epiost-config"
)

install(TARGETS gconfigsig
	RUNTIME DESTINATION ${TEAPOD_INSTALL_BIN_DIR}
)
