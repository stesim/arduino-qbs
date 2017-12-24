import qbs
import qbs.FileInfo
import qbs.Environment
import "qbs/imports/arduino/ArduinoProject.qbs" as ArduinoProject
import "qbs/imports/arduino/ArduinoLibrary.qbs" as ArduinoLibrary

ArduinoProject {
    minimumQbsVersion: "1.7.1"

    arduinoPlatformModule: "qtc-arduino"
    arduinoPlatformPath: FileInfo.joinPaths(Environment.getEnv("HOME"), ".arduino15/packages/arduino/hardware/avr/1.6.17")
    arduinoToolsPath: FileInfo.joinPaths(Environment.getEnv("HOME"), ".arduino15/packages/arduino/tools/")
    arduinoToolchainPath: FileInfo.joinPaths(Environment.getEnv("HOME"), ".arduino15/packages/arduino/tools/avr-gcc/4.9.2-atmel3.5.3-arduino2")
    arduinoLibraryPaths: [FileInfo.joinPaths(arduinoPlatformPath, "libraries"), FileInfo.joinPaths(Environment.getEnv("HOME"), "Arduino/libraries")]

    arduinoMCU: "atmega2560"
    arduinoFrequency: "16000000L"

    arduinoCore: "arduino"
    arduinoVariant: "mega"

    ArduinoLibrary { name: "SPI" }

    CppApplication {
        name: "arduino-qbs"
        consoleApplication: true
        type: ["application", "hex"]

        files: [
            "main.cpp",
        ]

        Depends { name: "core" }
        Depends { name: "SPI" }

        Rule {
            inputs: ["application"]
            Artifact {
                filePath: input.completeBaseName + ".hex"
                fileTags: ["hex"]
            }
            prepare: {
                var objcopy = product.moduleProperty("cpp", "objcopyPath");
                var args = ["-O", "ihex", "-R", ".eeprom", input.filePath, output.filePath];
                var cmd = new Command(objcopy, args)
                cmd.description = "extracting hex from elf: " + input.filePath;
                cmd.highlight = "filegen";

                return cmd;
            }
        }

        Group {
            fileTagsFilter: product.type
            qbs.install: true
        }
    }
}
