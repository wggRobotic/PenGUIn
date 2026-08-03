cmake_minimum_required(VERSION 3.20)
project(controller_package)

# Apply the C++ standard
if(NOT CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 20)
  set(CMAKE_CXX_STANDARD_REQUIRED ON)
endif()

# Apply the C standard
if(NOT CMAKE_C_STANDARD)
  set(CMAKE_C_STANDARD 17)
endif()

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

# find dependencies
find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(std_msgs REQUIRED)

# Add an exectuable: "add_executable(<executable_name> <relativ_path>)"
add_executable(penGUIn_controller src/penGUIn_controller.cpp)
set_target_properties(penGUIn_controller PROPERTIES LINKER_LANGUAGE CXX)

# Link all dependencies for the executable: "target_link_libraries(<executable_name> PUBLIC <dependencies>)"
target_link_libraries(
  penGUIn_controller PUBLIC
  rclcpp::rclcpp
  std_msgs::std_msgs
  penguin_interface_package::penguin_interface_package
)

target_include_directories(penGUIn_controller PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  $<INSTALL_INTERFACE:include>
)

install (TARGETS
	# Install the executable: <executable_name>
	penGUIn_controller
	DESTINATION lib/${PROJECT_NAME}/
)

ament_package()
