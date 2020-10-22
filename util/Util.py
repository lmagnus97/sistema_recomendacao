from datetime import datetime


class Util:

    # VERIFICA SE O DIA DA AVALIACAO ESTA NO CONTEXTO
    @staticmethod
    def is_context_dayweek(day_rating):
        is_weekend = datetime.today().weekday() == 5 or datetime.today().weekday() == 6

        if is_weekend and (day_rating == 5 or day_rating == 6):
            return True
        elif (not is_weekend) and (day_rating != 5 and day_rating != 6):
            return True
        else:
            return False

    # VERIFICA SE O DIA DA AVALIACAO ESTA NO CONTEXTO
    @staticmethod
    def is_context_hour_day(item_hour):
        is_night = datetime.today().hour >= 18
        is_item_night = item_hour >= 18

        if is_night == is_item_night:
            return True
        else:
            return False
