default: release

.PHONY: default release debug all clean

include make-utils/flags.mk
include make-utils/cpp-utils.mk

SQRT_VALUE=5000000

WARNING_FLAGS += -Wno-missing-field-initializers
CXX_FLAGS += -DSQRT_VALUE=$(SQRT_VALUE) -ICatch/include

$(eval $(call use_cpp11))

ifneq (,$(CLANG_USE_LIBCXX))
$(eval $(call use_libcxx))
endif

$(eval $(call src_folder_compile,))
$(eval $(call src_folder_compile,/vector_list_update_1,-Iplf_colony))


$(eval $(call add_src_executable,vector_list_update_1,vector_list_update_1/bench.cpp graphs.cpp demangle.cpp))

$(eval $(call add_executable_set,vector_list_update_1,vector_list_update_1))

release: release_vector_list_update_1
all: release

sonar: release
	cppcheck --xml-version=2 --enable=all --std=c++11 src include 2> cppcheck_report.xml
	/opt/sonar-runner/bin/sonar-runner

clean:
	rm -rf release/

-include $(DEBUG_D_FILES)
-include $(RELEASE_D_FILES)
