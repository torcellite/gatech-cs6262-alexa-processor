import sys

def merge_files(files, merged_filename):
    # Read all files and load content to memory
    content = []
    sites = 0
    for _ in files:
        lines = []
        with open(_, 'r') as f:
            lines = f.readlines()
        sites += len(lines)
        if len(lines) > 0:
            content.append(lines)

    # Interleave lines
    output = ''
    while sites > 0:
        idx = 0
        while idx < len(content):
            output += content[idx].pop(0)
            if len(content[idx]) == 0:
                content.pop(idx)
            idx += 1
            sites -= 1
    # Write new file
    with open(merged_filename, 'w') as f:
        f.write(output)

if __name__ == '__main__':
    if len(sys.argv) < 4:
        print 'Usage is python merge_heuristic_lists merged_filename file1 file2 [file3]...'
    else:
        merge_files(sys.argv[2:], sys.argv[1])
