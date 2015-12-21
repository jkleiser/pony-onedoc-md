// This version handles the new mkdocs.yml format introduced in 0.1.6
// Adjusted to work with half-open String.substring(start, end), and ISize

use "files"

actor Main
  let _env: Env
  var _docsPath: String = ""
  var _currentChpName: String = ""
  var _currentChpNameWritten: Bool = false
  
  new create(env: Env) =>
    _env = env
    try
      if _env.args.size() != 3 then
        _env.err.print("Two path arguments are required: input dir. and output file")
        error
      end
      let dirPath = _env.args(1)                              //  /PATH/TO/pony-tutorial
      let outFile = File(FilePath(_env.root, _env.args(2)))   //  /PATH/TO/one.md
      let ymlPath = Path.join(dirPath, "mkdocs.yml")
      var filesConcatenated: U16 = 0
      _docsPath = Path.join(dirPath, "docs")
      with ymlFile = File.open(FilePath(_env.root, ymlPath)) do
        for line in ymlFile.lines() do
          try
            let hyphen: ISize = line.find("- ")
            var chpName: String = ""
            var mdPath: String = ""
            try
              let colon: ISize = line.find(":")
              chpName = line.substring(hyphen + 2, colon)
              if line.at("d", -1) then
                // mdPath after colon, line ends with .md
                mdPath = line.substring(colon + 2)
              end
            else
              // No colon
              mdPath = line.substring(hyphen + 2)
              try
                let mdName: String = mdPath.split("/")(1)
                chpName = capitalize(mdName.substring(0, -3).replace("-", " "))
              end
            end
            
            if (hyphen == 0) and (chpName != "") and (chpName != _currentChpName) then
              _currentChpName = chpName
              _currentChpNameWritten = false
            end
            
            if mdPath != "" then
              let mdFullPath: String = Path.join(_docsPath, mdPath)
              let mdInfo = FileInfo(FilePath(_env.root, mdFullPath))
              if mdInfo.size > 0 then
                if not _currentChpNameWritten then
                  outFile.print("\n___\n" + _currentChpName + "\n===\n")
                  //_env.out.print(_currentChpName)
                  _currentChpNameWritten = true
                else
                  outFile.write("\n")
                end
                //_env.out.print("  " + mdPath + ", " + mdInfo.size.string())
                appendFileToResult(mdFullPath, if hyphen > 0 then chpName else "" end, outFile)
                filesConcatenated = filesConcatenated + 1
              end
            end
          end  // try
        end  // for
      end  // with
      outFile.dispose()
      _env.out.print("Done: " + filesConcatenated.string() + " files concatenated")
    else
      _env.err.print("An error occurred in Main.create")
      _env.exitcode(-1)
    end

  fun capitalize(src: String box): String =>
    src.substring(0, 1).upper() + src.substring(1)

  fun ref appendFileToResult(mdFullPath: String, parName: String, result: File) =>
    try
      let mdFile = File.open(FilePath(_env.root, mdFullPath))
      if parName != "" then
        //result.print("§ " + parName + "\n---\n")
        result.print("<h2 class=\"chap\">" + parName + "</h2>\n")
      end
      for line in mdFile.lines() do
        result.print(line)
      end
      mdFile.dispose()
    else
      _env.out.print("appendFileToResult failed: " + mdFullPath)
    end
