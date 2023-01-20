# JDK version
jdk() {
  version=$1
	[[ ! -f /usr/libexec/java_home ]] || export JAVA_HOME=$(/usr/libexec/java_home -v"$version");
  java -version
}
