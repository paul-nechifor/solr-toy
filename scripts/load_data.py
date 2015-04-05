#!/usr/bin/env python2

import json
import os
import urllib2

root = os.path.join(os.path.dirname(os.path.realpath(__file__)), '..')


def main():
    path = os.path.join(root, 'private', 'jeopardy.json')
    if not os.path.exists(path):
        print "JSON file doesn't exist:", path
        exit(1)

    data = transform_json(path)
    req = urllib2.Request('http://172.16.60.10:8983/solr/jeopardy/update')
    req.add_header('Content-Type', 'application/json')
    print urllib2.urlopen(req, data)


def transform_json(path):
    list = []
    with open(path) as f:
        for i, record in enumerate(json.load(f)):
            list.append({
                'question_id': i + 2,
                'category': record['category'],
                'text': record['question'],
            })
    return json.dumps(list)


if __name__ == '__main__':
    main()
