FROM phusion/baseimage:0.9.21
ENV DEBIAN_FRONTEND noninteractive

# First, install add-apt-repository and bzip2
# Add oracle-jdk8 to repositories
# Install oracle-jdk8
# Install Ruby
# JAVA_VERSION environment variable to foce rebuild. Set to version at ppa http://www.ubuntuupdates.org/ppa/webupd8_java.
ENV JAVA_VERSION 8u131-1~webupd8~2
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
ENV ANDROID_SDK_VER 3859397
RUN curl -sf -o sdk-tools-linux-$ANDROID_SDK_VER.zip -L https://dl.google.com/android/repository/sdk-tools-linux-$ANDROID_SDK_VER.zip && \
    unzip sdk-tools-linux-$ANDROID_SDK_VER.zip && \
    mkdir /usr/local/android-sdk && \
    mv tools /usr/local/android-sdk/tools && \
    rm sdk-tools-linux-$ANDROID_SDK_VER.zip

# Install Android tools
# Environment variables to force rebuild of image when SDK maven repos are updated.
ENV ANDROID_SUPPORT_REPO 47
ENV GOOGLE_REPO 47
COPY android-sdk-license /tmp/
RUN mkdir /usr/local/android-sdk/licenses && \
    mv /tmp/android-sdk-license /usr/local/android-sdk/licenses/ && \
    /usr/local/android-sdk/tools/bin/sdkmanager \
                        "tools" "platform-tools" \
                        "build-tools;25.0.3" \
                        "platforms;android-25" \
                        "extras;android;m2repository" \
                        "extras;google;m2repository"

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
