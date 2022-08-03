def main():
    from app import io

    o365_configuration_file = 'data/o365.json'
    configuration = io.read(o365_configuration_file)
    account = connect_to_o365(configuration['client_id'], configuration['client_secret'], configuration['protocol'],
                              configuration['auth_flow_type'], configuration['tenant_id'], configuration['scopes'])
    print(f'Authenticated: {account}')


def connect_to_o365(client_id, client_secret, protocol=None, auth_flow_type='authorization', tenant_id=None,
                    user_provided_scopes=None):
    from O365 import Account

    try:
        protocol = get_protocol(protocol)
        user_provided_scopes = get_scopes(user_provided_scopes)
        credentials = (client_id, client_secret)
        scopes = protocol.get_scopes_for(user_provided_scopes)
        account = Account(credentials, auth_flow_type=auth_flow_type, tenant_id=tenant_id)

        return account.authenticate(scopes=scopes)

    except Exception:
        return False


def get_protocol(protocol):
    from O365 import MSGraphProtocol, MSOffice365Protocol

    if protocol == 'MSOffice365Protocol':
        return MSOffice365Protocol()

    return MSGraphProtocol()


def get_scopes(user_provided_scopes):
    if user_provided_scopes:
        return user_provided_scopes

    return ['https://graph.microsoft.com/.default']
