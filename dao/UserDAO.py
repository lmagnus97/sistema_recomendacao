from db.Connection import Connection


class UserDAO:

    @staticmethod
    def add(data):
        col_users = Connection.db()["users"]

        return col_users.insert(data)
