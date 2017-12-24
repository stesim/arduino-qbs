import qbs
import qbs.FileInfo

Project {
    qbsSearchPaths: "../../"

    qbs.toolchain: "gcc"      // TODO: move to platform dependent file
    qbs.architecture: "avr6"  // TODO: move to platform dependent file
    qbs.enableDebugCode: true // TODO: move to platform dependent file

    property string arduinoPlatformModule: undefined

    property path arduinoPlatformPath: undefined
    property path arduinoToolsPath: undefined
    property path arduinoToolchainPath: undefined
    property pathList arduinoLibraryPaths: []

    property string arduinoMCU: undefined
    property string arduinoFrequency: undefined

    property string arduinoCore: undefined
    property string arduinoVariant: undefined

    StaticLibrary {
        condition: {
            var val = project.arduinoPlatformModule &&
                    project.arduinoPlatformPath &&
                    project.arduinoCore &&
                    project.arduinoVariant;

            if( !val )
            {
                console.error("Arduino core library disabled. Check project properties: " +
                              "arduinoPlatformModule, arduinoPlatformPath, arduinoCore, arduinoVariant");
            }

            return val;
        }
        name: "core"

        Depends { name: project.arduinoPlatformModule }

        property path arduinoCorePath:    FileInfo.joinPaths(arduinoPlatformPath, "cores", project.arduinoCore)
        property path arduinoVariantPath: FileInfo.joinPaths(arduinoPlatformPath, "variants", project.arduinoVariant)

        Group {
            name: "sources"
            files: ["*.S", "*.c", "*.cpp", "*.h", "*.hpp"]
            prefix: arduinoCorePath + "/**/"
        }

        cpp.includePaths: [arduinoCorePath, arduinoVariantPath]

        Export {
            Depends { name: "cpp" }
            Depends { name: project.arduinoPlatformModule }

            cpp.includePaths: [product.arduinoCorePath, product.arduinoVariantPath]
        }
    }
}
