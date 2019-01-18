FROM openjdk:8

MAINTAINER Oleksii Dankov <denimkqqa@gmail.com>

# Install Git and dependencies
RUN dpkg --add-architecture i386 \
 && apt-get update \
 && apt-get install -y file git curl zip libncurses5:i386 libstdc++6:i386 zlib1g:i386 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists /var/cache/apt

# Set up environment variables
ENV ANDROID_HOME="/home/user/android-sdk-linux" \
    SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip" 

# Create a non-root user
RUN useradd -m user
USER user
WORKDIR /home/user

# Download Android SDK
RUN mkdir "$ANDROID_HOME" .android \
 && cd "$ANDROID_HOME" \
 && curl -o sdk.zip $SDK_URL \
 && unzip sdk.zip \
 && rm sdk.zip \
 && yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses


#Installl build tools
RUN /home/user/android-sdk-linux/tools/bin/sdkmanager "platforms;android-28"
RUN /home/user/android-sdk-linux/tools/bin/sdkmanager "build-tools;28.0.1"

ENV BUILD_TOOLS "/home/user/android-sdk-linux/build-tools/28.0.1/"
ENV PLATFORM "/home/user/android-sdk-linux/platforms/android-28/android.jar"

#install Kotlinc

RUN cd /usr/lib && \
    wget https://github.com/JetBrains/kotlin/releases/download/v1.3.11/kotlin-compiler-1.3.11.zip && \
    unzip kotlin-compiler-*.zip && \
    rm kotlin-compiler-*.zip && \
    rm -f kotlinc/bin/*.bat

ENV PATH $PATH:/usr/lib/kotlinc/bin

CMD ["kotlinc"]
