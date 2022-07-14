def parse(xml_input, encoding=None):
    import xmltodict

    root = 'dataExport'
    dictionary = xmltodict.parse(xml_input, encoding)
    table = list(dictionary[root])[-1]
    data = None

    if dictionary[root][table]:
        array = list(dictionary[root][table])[0]
        data = dictionary[root][table][array]

    return table, data
