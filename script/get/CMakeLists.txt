
add_executable(getsig
	get.cpp
)

target_compile_features(getsig PUBLIC cxx_std_17)

target_link_libraries(getsig
	teapod::fileformat
)

set_target_properties(getsig
	PROPERTIES
		OUTPUT_NAME "epiost-get"
)

install(TARGETS getsig
	RUNTIME DESTINATION ${TEAPOD_INSTALL_BIN_DIR}
)
