import qbs
import qbs.File
import qbs.FileInfo

StaticLibrary {
    qbsSearchPaths: "../../"

    Depends { name: "cpp" }
	//Depends { name: project.arduinoPlatformModule }
    Depends { name: "core" }

    property path libraryPath: {
        for(var i = 0; i < project.arduinoLibraryPaths.length; ++i)
        {
            var path = FileInfo.joinPaths(project.arduinoLibraryPaths[i], name);
            if(File.exists(FileInfo.joinPaths(path, name + ".h")))
            {
                return path
            }
            else if(File.exists(FileInfo.joinPaths(path, "src", name + ".h")))
            {
                return FileInfo.joinPaths(path, "src")
            }
        }

        console.error("Arduino library '" + name + "' was not found.")
        return undefined
    }

	Group {
		name: "sources"
		files: ["*.S", "*.c", "*.cpp", "*.h", "*.hpp"]
		prefix: product.libraryPath + "/**/"
	}

    Export {
        Depends { name: "cpp" }

        cpp.includePaths: product.cpp.includePaths.concat([product.libraryPath])
    }
}
