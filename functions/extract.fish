function extract --description "Extract file"
    set -l options 'o/output=' 'h/help'
    argparse $options -- $argv

    # Check if we're in a Chinese environment
    set -l is_chinese_env 0
    if string match -qr "zh" $LANG; or string match -qr "zh" $LC_ALL; or string match -qr "zh" $LC_MESSAGES
        set is_chinese_env 1
    end

    # display usage if no parameters given or help flag provided
    if test -z "$argv" -o -n "$_flag_help"
        if test $is_chinese_env -eq 1
            echo "\
用法: extract [-o|--output <路径>] 文件
支持格式:
  zip     rar    7z      tar.bz2  tbz2    tbz
  tb2     tar.gz tgz     tar.xz   txz     tar.lzma
  tlz     tar    bz2     gz       xz      lzma

如果未指定输出路径，则解压到当前路径。
如果输出文件的目录不存在，将自动创建。"
        else
            echo "\
Usage: extract [-o|--output <path>] file
Support format:
  zip     rar    7z      tar.bz2  tbz2    tbz
  tb2     tar.gz tgz     tar.xz   txz     tar.lzma
  tlz     tar    bz2     gz       xz      lzma

If no output path is specified, files will be extracted to the current directory.
If the output file's directory doesn't exist, it will be created automatically."
        end
        if test -n "$_flag_help"
            return 0
        else
            return 1
        end
    end

    if not test -f "$argv"
        if test $is_chinese_env -eq 1
            echo "文件不存在: $argv" 
        else
            echo "File does not exist: $argv" 
        end
        return 1
    end

    # Check if output directory exists
    set -l output_dir "."
    if set -q _flag_output
        set output_dir $_flag_output
        if not test -d $output_dir
            mkdir -p $output_dir
            or begin
                if test $is_chinese_env -eq 1
                    echo "无法创建输出目录: $output_dir"
                else
                    echo "Unable to create output directory: $output_dir"
                end
                return 1
            end
        end
    end

    set -l file_path (realpath $argv)
    set -l file_name (basename $file_path)

    switch $file_path
        case "*.zip"
            unzip -q $file_path -d $output_dir
        case "*.rar"
            unrar x -inul $file_path $output_dir
        case "*.7z"
            7z x -bd $file_path -o$output_dir >/dev/null
        case "*.tar.bz2" "*.tbz2" "*.tbz" "*.tb2"
            tar xjf $file_path -C $output_dir
        case "*.tar.gz" "*.tgz"
            tar xzf $file_path -C $output_dir
        case "*.tar.xz" "*.txz"
            tar xJf $file_path -C $output_dir
        case "*.tar.lzma" "*.tlz"
            tar --lzma -xf $file_path -C $output_dir
        case "*.tar"
            tar xf $file_path -C $output_dir
        case "*.bz2"
            set -l output_file (string replace -r '\.bz2$' '' $file_name)
            bunzip2 -c $file_path > $output_dir/$output_file
        case "*.gz"
            set -l output_file (string replace -r '\.gz$' '' $file_name)
            gunzip -c $file_path > $output_dir/$output_file
        case "*.xz"
            set -l output_file (string replace -r '\.xz$' '' $file_name)
            xz -d -c $file_path > $output_dir/$output_file
        case "*.lzma"
            set -l output_file (string replace -r '\.lzma$' '' $file_name)
            xz -d -c $file_path > $output_dir/$output_file
        case "*"
            if test $is_chinese_env -eq 1
                echo "未知的归档格式: $file_path"
            else
                echo "Unknown archive format: $file_path"
            end
            return 1
    end

    if test $is_chinese_env -eq 1
        echo "文件 $file_path 已被解压到 $output_dir"
    else
        echo "File $file_path has been extracted to $output_dir"
    end
end
