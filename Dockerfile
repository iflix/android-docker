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
ENV ANDROID_SUPPORT_VERSION 23.2.1
RUN (while :; do echo 'y'; sleep 2; done) | /usr/local/android-sdk/tools/android update sdk --filter extra-android-support,extra-android-m2repository,platform-tool --no-ui -a
RUN (while :; do echo 'y'; sleep 2; done) | /usr/local/android-sdk/tools/android update sdk --filter build-tools-22.0.1,build-tools-23.0.1,build-tools-23.0.2,build-tools-23.0.3,build-tools-21.1.2,build-tools-21.0.3,android-21,android-22,android-15,android-23 --no-ui -a
RUN (while :; do echo 'y'; sleep 2; done) | /usr/local/android-sdk/tools/android update sdk --filter extra-google-google_play_services,extra-google-m2repository --no-ui -a

# Environment variables
ENV ANDROID_HOME /usr/local/android-sdk
ENV ANDROID_SDK_HOME $ANDROID_HOME
ENV ANDROID_NDK_HOME /usr/local/android-ndk
ENV GRADLE_HOME /opt/gradle
ENV PATH $PATH:$ANDROID_SDK_HOME/tools
ENV PATH $PATH:$ANDROID_SDK_HOME/platform-tools
ENV PATH $PATH:$GRADLE_HOME/bin

# Export JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Install gradle
RUN mkdir -p /opt/packages/gradle
WORKDIR /opt/packages/gradle
RUN wget https://services.gradle.org/distributions/gradle-2.10-bin.zip
RUN unzip gradle-2.10-bin.zip
RUN ln -s /opt/packages/gradle/gradle-2.10/ /opt/gradle

#Install Ruby

RUN apt-add-repository ppa:brightbox/ruby-ng
RUN apt-get update

RUN apt-get install -y ruby2.3 
RUN apt-get install -y ruby2.3-dev
RUN gem install bundler
RUN apt-get install -y build-essential

WORKDIR /workspace

RUN mkdir -p /root/.gradle
ENV HOME /root
VOLUME /root/.gradle
