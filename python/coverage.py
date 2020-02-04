from __future__ import print_function
import sys
import json


def separate_lines(file_coverage):
    separated = []
    for line in file_coverage['executed_lines']:
        separated.append((line, 'executed'))
    for line in file_coverage['missing_lines']:
        separated.append((line, 'missing'))
    for line in file_coverage['excluded_lines']:
        separated.append((line, 'excluded'))

    return separated


def parse(input_data, filename):
    coverage_json = json.loads(input_data)

    if not filename in coverage_json['files']:
        print("no coverage present for file '%s'" %
              (filename), file=sys.stderr)
        return []

    separated = separate_lines(coverage_json['files'][filename])
    return separated
