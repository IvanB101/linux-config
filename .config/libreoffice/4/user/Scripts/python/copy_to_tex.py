import uno
import subprocess
import platform
import sys
import re

info = []

def format(content: str = "", colspan: int = 1, rowspan: int = 1) -> str:
    if colspan > 1:
        content = f"\\multicolumn{{{colspan}}}{{c|}}{{{content}}}"
    if rowspan > 1:
        content = f"\\multirow{{{-rowspan}}}{{*}}{{{content}}}"

    return content

def to_idx(row: str) -> int:
    letters = ord("Z") - ord("A") + 1
    ord_a = ord("A")
    idx = ord(row[len(row) - 1]) - ord_a
    for i in range(len(row) - 1):
        idx += (ord(row[i]) + 1 - ord_a) * (letters ** (len(row) - i - 1))

    return idx

system = platform.system()
def copy_to_clipboard(content: str):
    if system == "Linux":
        subprocess.run(["xclip", "-selection", "clipboard"], input=content.encode("utf-8"), check=True)
    # not tested
    elif system == "Darwin":  # macOS
        subprocess.run(["pbcopy"], input=content.encode("utf-8"), check=True)
    # not tested
    elif system == "Windows":
        subprocess.run("clip", input=content.encode("utf-8"), shell=True, check=True)
    else:
        raise NotImplementedError(f"Clipboard copy not implemented for OS: {system}", sys)

def copy_to_tex():
    ctx = uno.getComponentContext()
    smgr = ctx.ServiceManager

    desktop = smgr.createInstanceWithContext("com.sun.star.frame.Desktop", ctx)
    doc = desktop.getCurrentComponent()

    if not hasattr(doc, "Sheets"):
        return

    controller = doc.getCurrentController()
    sheet = controller.getActiveSheet()
    selection = controller.getSelection()

    if not hasattr(selection, "getRangeAddress"):
        return

    col_count = selection.RangeAddress.EndColumn - selection.RangeAddress.StartColumn + 1
    row_count = selection.RangeAddress.EndRow - selection.RangeAddress.StartRow + 1
    data: list[list[str]] = [["_to_process"] * col_count for _ in range(row_count)]

    for row in range(row_count):
        for col in range(col_count):
            if data[row][col] != "_to_process":
                continue

            cell = sheet.getCellByPosition(
                selection.RangeAddress.StartColumn + col,
                selection.RangeAddress.StartRow + row
            )
            try:
                cellcursor = sheet.createCursorByRange(cell)
                cellcursor.collapseToMergedArea()
                # format AbsoluteName $Sheet1.$A$1:$D$2 for a merged cell of A1:D2
                _, _, cell_range = cellcursor.AbsoluteName.partition(".")
                start_cell, end_cell = cell_range.split(":")
                _, start_col, start_row = start_cell.split("$")
                _, end_col, end_row = end_cell.split("$")

                rowspan = int(end_row) - int(start_row) + 1
                colspan = to_idx(end_col) - to_idx(start_col) + 1

                for m_row in range(row, row + rowspan):
                    data[m_row][col] = format("", colspan, 1)
                    for m_col in range(col + 1, col + colspan):
                        data[m_row][m_col] = "_merged"
                data[row + rowspan - 1][col] = format(cell.getString(), colspan, rowspan)
            except:
                data[row][col] = cell.getString()

    output = []
    for row in data:
        row_data = filter(lambda c : c != "_merged", row)
        row_data = map(lambda c : c.replace("_", "\\_"), row_data)
        row_data = map(lambda c : re.sub(r'"(.*)"', r"``\1''", c), row_data)
        output.append(" & ".join(row_data) + " \\\\ \\hline")

    column_format = f"{{|{'l|' * len(data[0])}}}"
    begin = f"\\begin{{table}}[]\n\\begin{{tabular}}{column_format}\n"
    end = "\\end{tabular}\n\\end{table}\n"

    table = "\n".join(output) + "\n"
    copy_to_clipboard(begin + table + end)
    # copy_to_clipboard("\n".join(info))
