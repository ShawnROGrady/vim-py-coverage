import coverage
import vim


def parse_and_assign(input_data, file_name, dest):
    res = coverage.parse(vim.eval(input_data), vim.eval(file_name))
    fmted = []
    for line in res:
        fmted.append("%s:%s" % (line[0], line[1]))
    vim.command("let %s = %s" % (dest, fmted))
