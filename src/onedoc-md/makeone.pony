use "files"

actor Main
  let _env: Env
  var _docsPath: String = ""
  var _currentChpName: String = ""
  var _filesConcatenated: U16 = 0
  
  new create(env: Env) =>
    _env = env
    try
      if _env.args.size() != 3 then
        _env.err.print("Two path arguments are required: input dir. and output file")
        error
      end
      let dirPath = _env.args(1)                //  /PATH/TO/pony-tutorial
      let outFile = File.create(_env.args(2))   //  /PATH/TO/one.md
      let ymlPath = Path.join(dirPath, "mkdocs.yml")
      _docsPath = Path.join(dirPath, "docs")
      with ymlFile = File.open(ymlPath) do
        for line in ymlFile.lines() do
          try
            let bLeft: I64 = line.find("[")
            let qRight: I64 = line.find("\"", bLeft + 2)
            let mdPath: String = line.substring(bLeft + 2, qRight - 1)
            try
              let slash: I64 = mdPath.find("/")
              let chpName: String = mdPath.substring(0, slash - 1)
              let parName: String = mdPath.substring(slash + 1, -4)
              //_env.out.print(chpName + " - " + parName)
              appendFileToResult(mdPath, capitalize(replace(chpName, "-", " ")),
                capitalize(replace(parName, "-", " ")), outFile)
            else
              // index.md
              let commas: U64 = line.count(",")
              if commas >= 2 then
                try
                  let qChpL: I64 = line.find("\"", qRight + 1)
                  let qChpR: I64 = line.find("\"", qChpL + 1)
                  let chpName: String = line.substring(qChpL + 1, qChpR - 1)
                  let qParL: I64 = line.find("\"", qChpR + 1)
                  let qParR: I64 = line.find("\"", qParL + 1)
                  let parName: String = line.substring(qParL + 1, qParR - 1)
                  //_env.out.print(mdPath + ", " + chpName + ", " + parName)
                  appendFileToResult(mdPath, chpName, parName, outFile)
                else
                  _env.err.print("An error occurred handling index.md")
                end
              end
            end
          end
        end  // for
      end  // with
      outFile.dispose()
      _env.out.print("Done: " + _filesConcatenated.string() + " files concatenated")
    else
      _env.err.print("An error occurred in Main.create")
      _env.exitcode(-1)
    end

  fun capitalize(src: String box): String =>
    src.substring(0, 0).upper() + src.substring(1, -1)

  fun replace(src: String box, olds: String box, news: String box): String =>
    var res: String = src.clone()
    var offset: I64 = src.size().i64()
    try
      while offset > 0 do
        offset = res.rfind(olds, offset)
        res = if offset > 0 then res.substring(0, offset - 1) + news else news end +
          res.substring(offset + olds.size().i64(), -1)
      end
    end
    res

  fun ref appendFileToResult(mdPath: String, chpName: String, parName: String, result: File) =>
    try
      let mdFullPath: String = Path.join(_docsPath, mdPath)
      let mdInfo = FileInfo(mdFullPath)
      if mdInfo.size > 0 then
        let mdFile = File.open(mdFullPath)
        if chpName != _currentChpName then
          result.print("\n___\n" + chpName + "\n===\n")
          _currentChpName = chpName
        else
          result.write("\n")
        end
        result.print("§ " + parName + "\n---\n")
        for line in mdFile.lines() do
          result.print(line)
        end
        mdFile.dispose()
        _filesConcatenated = _filesConcatenated + 1
      end
    else
      _env.out.print("appendFileToResult failed: " + mdPath)
    end
