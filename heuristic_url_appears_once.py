import os
import sys

def get_urls(output):
    files = os.listdir('csv')
    files.sort(reverse=True)
    files = ['csv/' + _ for _ in files]

    urls_appear_once = []
    # Load initial set of urls
    with open(files[0]) as f:
	urls_appear_once = f.readlines()
    urls_appear_once = [_.split(',')[1] for _ in urls_appear_once]
    urls_appear_once = set(urls_appear_once)

    # Check against the other days
    files = files[1:]
    for _ in files:
        urls = []
        with open(_) as f:
            for line in f:
                url = line.split(',')[1]
                if url in urls_appear_once:
                    urls_appear_once.remove(url)

    with open(output, 'w') as f:
        f.write(''.join(urls_appear_once))

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print 'Usage is python heuristic_urls_appear_once.py output_filename'
    else:
        get_urls(sys.argv[1])
