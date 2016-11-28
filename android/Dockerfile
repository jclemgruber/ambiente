#####
# Ambiente 1.0
# Java as Base Image
######
FROM ambiente/java

MAINTAINER Joao Lemgruber <jclemgruber@gmail.com>

ENV ANDROID_SDK_URL="https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz" \
    ANDROID_BUILD_TOOLS_VERSION=25.0.0 \
    ANDROID_APIS="android-25,android-24,android-23,android-22,android-21" \
    ANT_HOME="/usr/share/ant" \
    MAVEN_HOME="/usr/share/maven" \
    GRADLE_HOME="/usr/share/gradle" \
    ANDROID_HOME="/opt/android-sdk-linux"

ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/$ANDROID_BUILD_TOOLS_VERSION:$ANT_HOME/bin:$MAVEN_HOME/bin:$GRADLE_HOME/bin

RUN dpkg --add-architecture i386 && \
    apt-get -qq update && \
    apt-get -qq install -y ant gradle libncurses5:i386 libstdc++6:i386 zlib1g:i386 && \

    # Installs Android SDK
    curl -sL ${ANDROID_SDK_URL} | tar xz -C /opt && \
    ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | android update sdk -a -u -t platform-tools,build-tools-${ANDROID_BUILD_TOOLS_VERSION},${ANDROID_APIS} && \
    chmod a+x -R $ANDROID_HOME && \
    chown -R root:root $ANDROID_HOME && \

    # Clean up
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get autoremove -y && \
    apt-get clean
