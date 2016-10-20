FROM phusion/baseimage:0.9.19
ENV DEBIAN_FRONTEND noninteractive

# First, install add-apt-repository and bzip2
# Add oracle-jdk8 to repositories
# Install oracle-jdk8
# Install Ruby
RUN echo "debconf shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections && \
    echo "debconf shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections && \
    apt-get update && \
    apt-get -y install software-properties-common python-software-properties curl bzip2 unzip openssh-client git lib32stdc++6 lib32z1 && \
    add-apt-repository ppa:webupd8team/java && \
    apt-add-repository ppa:brightbox/ruby-ng && \
    apt-get update && \
    apt-get -y install oracle-java8-installer ruby2.3 ruby2.3-dev build-essential && \
    gem install bundler && \
    rm -rf /var/cache/oracle-jdk8-installer && \
    apt-get -y remove software-properties-common python-software-properties && \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Install android sdk
ENV ANDROID_SDK_VER 24.4.1
RUN curl -sf -o android-sdk_r$ANDROID_SDK_VER-linux.tgz -L http://dl.google.com/android/android-sdk_r$ANDROID_SDK_VER-linux.tgz && \
    tar -xzf android-sdk_r$ANDROID_SDK_VER-linux.tgz && \
    mv android-sdk-linux /usr/local/android-sdk && \
    rm android-sdk_r$ANDROID_SDK_VER-linux.tgz

# Install Android tools
# Environment variables to force rebuild of image when SDK maven repos are updated.
ENV ANDROID_SUPPORT_VERSION 25.0.0
ENV GOOGLE_PLAY_SERVICES 9.6.1
RUN (while :; do echo 'y'; sleep 2; done) | /usr/local/android-sdk/tools/android update sdk --filter \
                        "tools,platform-tools, \
                        build-tools-24.0.2,build-tools-24.0.3, \
                        build-tools-25.0.0, \
                        android-24,android-25, \
                        extra-android-m2repository, \
                        extra-google-m2repository" \
                        --no-ui --all


# Environment variables
ENV ANDROID_HOME /usr/local/android-sdk
ENV ANDROID_SDK_HOME $ANDROID_HOME
ENV GRADLE_HOME /opt/gradle
ENV PATH $PATH:$ANDROID_SDK_HOME/tools
ENV PATH $PATH:$ANDROID_SDK_HOME/platform-tools
ENV PATH $PATH:$GRADLE_HOME/bin

# Export JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

WORKDIR /workspace

ENV HOME /root
