# Standard Flutter Dockerfile

## Components

|                            |          Note            |  
| -------------------------- | :-----------------------:| 
| Flutter                    |         3.0.0            |  
| Andorid Platform API       |         31 (Android 11)  |      
| Android Platform API       |         30 (Android 10)  |    
| Android Build Tool         |         33.0.0           |     
| Android Commandline Tool   |         7                |       
| Java JDK                   |         11               |
| Ubuntu                     |         22.04            |
| Platform                   |         linux/arm64/v8   |

## ⚠️ Warning
- Support for **ARM64** arc only. Intently build in x86_64 or other will lead to nowhere [(qemu bug)](https://github.com/docker/for-mac/issues/6264)
- Can't retrieve and install Android Build Tool 30.0.3