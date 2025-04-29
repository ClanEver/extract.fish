function extract --description "Extract file"
    set -l options 'o/output='
    argparse -n extract $options -- $argv

    if test -z "$argv"
        # display usage if no parameters given
        echo "Usage: extract [-o|--output <path>] <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|exe|tar.bz2|tar.gz|tar.xz|lzma>"
        return 1
    end

    if not test -f "$argv"
        echo "File does not exist: $argv" 
        return 1
    end

    # Check if output directory exists
    set -l output_dir "."
    if set -q _flag_output
        set output_dir $_flag_output
        if not test -d $output_dir
            mkdir -p $output_dir
            or begin
                echo "Unable to create output directory: $output_dir"
                return 1
            end
        end
    end

    set -l file_path $argv
    set -l file_name (basename $file_path)

    switch $file_path
        case "*.tar.bz2"
            tar xvjf $file_path -C $output_dir
        case "*.tar.gz"
            tar xvzf $file_path -C $output_dir
        case "*.tar.xz"
            tar xvJf $file_path -C $output_dir
        case "*.zip"
            unzip $file_path -d $output_dir
        case "*.rar"
            unrar x $file_path $output_dir
        case "*.bz2"
            # bunzip2 can only extract in source directory, so copy to target directory and extract there
            set -l dest_file $output_dir/$file_name:r
            cp $file_path $output_dir/$file_name
            bunzip2 $output_dir/$file_name
        case "*.gz"
            # gunzip can only extract in source directory, so copy to target directory and extract there
            set -l dest_file $output_dir/$file_name:r
            cp $file_path $output_dir/$file_name
            gunzip $output_dir/$file_name
        case "*.tar"
            tar xvf $file_path -C $output_dir
        case "*.tbz2"
            tar xvjf $file_path -C $output_dir
        case "*.tgz"
            tar xvzf $file_path -C $output_dir
        case "*.Z"
            # uncompress can only extract in source directory, so copy to target directory and extract there
            set -l dest_file $output_dir/$file_name:r
            cp $file_path $output_dir/$file_name
            uncompress $output_dir/$file_name
        case "*.7z"
            7z x $file_path -o$output_dir
        case "*.xz"
            # use -k to keep original file, and specify output path
            set -l dest_file $output_dir/(basename $file_path .xz)
            xz -d -k -c $file_path > $dest_file
        case "*.exe"
            cabextract $file_path -d $output_dir
        case "*.lzma"
            # use -k to keep original file, and specify output path
            set -l dest_file $output_dir/(basename $file_path .lzma)
            lzma -d -k -c $file_path > $dest_file
        case "*"
            echo "Unknown archive format: $file_path"
            return 1
    end

    echo "File $file_path has been extracted to $output_dir"
end
