import uno

localContext = uno.getComponentContext()
resolver = localContext.ServiceManager.createInstanceWithContext(
    "com.sun.star.bridge.UnoUrlResolver", localContext )
# connect to the running office
ctx = resolver.resolve( "uno:socket,host=localhost,port=2002;urp;StarOffice.ComponentContext" )
smgr = ctx.ServiceManager
desktop = smgr.createInstanceWithContext( "com.sun.star.frame.Desktop",ctx)
com = desktop.loadComponentFromURL(uno.systemPathToFileUrl("/workspace/summary/courier/2022-06-01_2022-06-30_andyonthewings.xlsx"), "_blank", 0, ())
sheet = com.CurrentController.ActiveSheet
# cols = sheet.getColumns()
cursor = sheet.createCursor()
cursor.gotoEndOfUsedArea(True)
cols = cursor.getColumns()
rows = cursor.getRows()

for col in cols:
    col.OptimalWidth = True

for row in rows:
    row.OptimalHeight = True

# cols.getByName("A").OptimalWidth = True
# cols.getByName("B").OptimalWidth = True
# cols.getByName("C").OptimalWidth = True
# cols.getByName("D").OptimalWidth = True
# cols.getByName("E").OptimalWidth = True
# cols.getByName("F").OptimalWidth = True
com.store()
com.dispose()
exit()