FROM phusion/baseimage:0.11
ENV DEBIAN_FRONTEND noninteractive

# First, install add-apt-repository and bzip2
# Install Ruby
RUN apt-get update && \
    apt-get -y install software-properties-common curl bzip2 unzip openssh-client git lib32stdc++6 lib32z1 && \
    apt-add-repository ppa:brightbox/ruby-ng && \
    apt-get update && \
    apt-get -y install openjdk-8-jdk-headless ruby2.5 ruby2.5-dev build-essential && \
    gem install bundler && \
    apt-get -y remove software-properties-common python-software-properties && \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Install android sdk
ENV ANDROID_SDK_VER 4333796
RUN curl -sf -o sdk-tools-linux-$ANDROID_SDK_VER.zip -L https://dl.google.com/android/repository/sdk-tools-linux-$ANDROID_SDK_VER.zip && \
    unzip sdk-tools-linux-$ANDROID_SDK_VER.zip && \
    mkdir /usr/local/android-sdk && \
    mv tools /usr/local/android-sdk/tools && \
    rm sdk-tools-linux-$ANDROID_SDK_VER.zip

# Install Android tools
# Environment variables to force rebuild of image when SDK maven repos are updated.
COPY android-sdk-license /tmp/
RUN mkdir /usr/local/android-sdk/licenses && \
    mv /tmp/android-sdk-license /usr/local/android-sdk/licenses/ && \
    /usr/local/android-sdk/tools/bin/sdkmanager \
                        "tools" "platform-tools" \
                        "build-tools;29.0.1" \
                        "platforms;android-29"

# Environment variables
ENV ANDROID_HOME /usr/local/android-sdk
ENV ANDROID_SDK_HOME $ANDROID_HOME
ENV PATH $PATH:$ANDROID_SDK_HOME/tools/bin
ENV PATH $PATH:$ANDROID_SDK_HOME/platform-tools

# Export JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

WORKDIR /workspace

ENV HOME /root
