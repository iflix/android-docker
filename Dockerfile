FROM phusion/baseimage:0.9.18
ENV DEBIAN_FRONTEND noninteractive

RUN echo "debconf shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
RUN echo "debconf shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections

# First, install add-apt-repository and bzip2
RUN apt-get update
RUN apt-get -y install software-properties-common python-software-properties bzip2 unzip openssh-client git lib32stdc++6 lib32z1

# Add oracle-jdk8 to repositories
RUN add-apt-repository ppa:webupd8team/java

# Update apt
RUN apt-get update

# Install oracle-jdk8
RUN apt-get -y install oracle-java8-installer

# Install android sdk
RUN wget http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz
RUN tar -xvzf android-sdk_r24.4.1-linux.tgz
RUN mv android-sdk-linux /usr/local/android-sdk
RUN rm android-sdk_r24.4.1-linux.tgz

# Install Android tools
RUN (while :; do echo 'y'; sleep 2; done) | /usr/local/android-sdk/tools/android update sdk --filter extra-android-support,extra-android-m2repository,platform-tool --no-ui -a
RUN (while :; do echo 'y'; sleep 2; done) | /usr/local/android-sdk/tools/android update sdk --filter build-tools-23.0.1,build-tools-23.0.2,build-tools-21.1.2,build-tools-21.0.3,android-21,android-15,android-23 --no-ui -a
RUN (while :; do echo 'y'; sleep 2; done) | /usr/local/android-sdk/tools/android update sdk --filter extra-google-google_play_services,extra-google-m2repository --no-ui -a

# Environment variables
ENV ANDROID_HOME /usr/local/android-sdk
ENV ANDROID_SDK_HOME $ANDROID_HOME
ENV ANDROID_NDK_HOME /usr/local/android-ndk
ENV PATH $PATH:$ANDROID_SDK_HOME/tools
ENV PATH $PATH:$ANDROID_SDK_HOME/platform-tools

# Export JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
