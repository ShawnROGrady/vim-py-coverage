from __future__ import print_function

import json
import sys

import coverage


def main():
    if len(sys.argv) < 2:
        print("filename and coverage json required", file=sys.stderr)
        return 1

    filename = sys.argv[1]
    json_arg = ""
    if len(sys.argv) == 3:
        json_arg = sys.argv[2]

    coverage_json = {}
    if json_arg == "" or json_arg == "-":
        piped_data = ""
        for line in sys.stdin:
            piped_data += line
        coverage_json = json.loads(piped_data)
    else:
        with open(json_arg) as f:
            coverage_json = json.load(f)

    if filename not in coverage_json["files"]:
        print("no coverage present for file '%s'" % (filename), file=sys.stderr)
        return 1

    separated = coverage.separate_lines(coverage_json["files"][filename])
    for line in separated:
        print("%s:%s" % (line[0], line[1]))

    return 0


if __name__ == "__main__":
    sys.exit(main())
