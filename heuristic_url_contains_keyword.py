import sys

keywords = [
    "virus",
    "download",
    "flash",
]

def get_sites(current_alexa, output_file):
    lines = []
    with open(current_alexa, 'r') as f:
        lines = f.readlines()

    output = ''
    for line in lines:
        tokens = line.strip().split(',')
        for word in keywords:
            if word in tokens[1]:
                output = output + tokens[1] + '\n'
                break

    with open(output_file, 'w') as f:
        f.write(output)

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print 'Usage is python heuristic_url_contains_keyword current_alexa output_file'
    else:
        current_alexa = sys.argv[1]
        output_file = sys.argv[2]
        get_sites(current_alexa, output_file)
