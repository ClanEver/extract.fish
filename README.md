# extract.fish

`extract` - automatically recognize file format and extract to current path for [fish shell](https://github.com/fish-shell/fish-shell).

## Install

Install with [Fisher](https://github.com/jorgebucaran/fisher):

    fisher install ClanEver/extract.fish

## Usage

```console
❯ extract -h
Usage: extract [-o|--output <path>] file
Support format:
  zip     rar    7z      tar.bz2  tbz2    tbz
  tb2     tar.gz tgz     tar.xz   txz     tar.lzma
  tlz     tar    bz2     gz       xz      lzma

If no output path is specified, files will be extracted to the current directory.
If the output file's directory doesn't exist, it will be created automatically.

# 中文环境
❯ extract -h
用法: extract [-o|--output <路径>] 文件
支持格式:
  zip     rar    7z      tar.bz2  tbz2    tbz
  tb2     tar.gz tgz     tar.xz   txz     tar.lzma
  tlz     tar    bz2     gz       xz      lzma

如果未指定输出路径，则解压到当前路径。
如果输出文件的目录不存在，将自动创建。
```

## Credits

Modified from [BUGBOUNTYchrisg8691/extract.fish](https://gist.github.com/BUGBOUNTYchrisg8691/7ca2095416b3be3da2f2ebd6c7af707a)

