import qbs
import qbs.FileInfo

Module {
    Depends { name: "cpp" }

    cpp.archiverName: "gcc-ar"
    cpp.assemblerFlags: ["-x", "assembler-with-cpp", "-flto"]
    cpp.cFlags: ["-ffunction-sections", "-fdata-sections", "-flto", "-fno-fat-lto-objects"]
    cpp.cLanguageVersion: "gnu11"
    cpp.cxxFlags: ["-ffunction-sections", "-fdata-sections", "-fno-threadsafe-statics", "-flto"]
    cpp.cxxLanguageVersion: "gnu++11"
    cpp.debugInformation: true
    cpp.defines: ["F_CPU=" + project.arduinoFrequency, "ARDUINO=10805"]
    cpp.driverFlags: ["-mmcu=" + project.arduinoMCU]
    cpp.enableExceptions: false
    cpp.executableSuffix: ".elf"
    cpp.optimization: "small"
    cpp.linkerFlags: ["--gc-sections"]
    cpp.positionIndependentCode: false
    cpp.toolchainInstallPath: FileInfo.joinPaths(project.arduinoToolchainPath, "bin")
    cpp.toolchainPrefix: "avr-"
}
