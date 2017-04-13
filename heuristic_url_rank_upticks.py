import sys

def get_sites(previous_alexa, current_alexa, minimum_delta, date):
    lines = []
    with open(previous_alexa, 'r') as f:
        lines = f.readlines()

    delta = {}
    for line in lines:
        tokens = line.strip().split(',')
        delta[tokens[1]] = int(tokens[0])

    with open(current_alexa, 'r') as f:
        lines = f.readlines()

    output = ''
    for line in lines:
        tokens = line.strip().split(',')
        if tokens[1] in delta:
            tokens[0] = int(tokens[0])
            if delta[tokens[1]] - tokens[0] >= minimum_delta:
                print tokens[1], delta[tokens[1]], tokens[0]
                # output = output + '%s,%d\n' % (tokens[1], tokens[0] - delta[tokens[1]])
                output = output + tokens[1] + '\n'
        else:
            # URL was not found in "previous_alexa", but is found in "current_alexa"
            delta[tokens[1]] = None

    with open(date + '_url_rank_drops', 'w') as f:
        f.write(output)

if __name__ == '__main__':
    if len(sys.argv) < 5:
        print 'Usage is python heuristic_url_drop_in_rank previous_alexa current_alexa minimum_delta date'
    else:
        previous_alexa = sys.argv[1]
        current_alexa = sys.argv[2]
        minimum_delta = int(sys.argv[3])
        date = sys.argv[4]
        get_sites(previous_alexa, current_alexa, minimum_delta, date)
