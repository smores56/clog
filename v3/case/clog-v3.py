import cadquery as cq

pcb = cq.importers.importStep("/home/smores/dev/keyboards/clog-v3/case/clog-v3.step")
print(pcb)