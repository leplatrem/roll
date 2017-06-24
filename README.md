# Roll

Let's roll.


## Install

    pip install roll


## Getting started

    from roll import Roll

    myapp = Roll()

    @myapp.route('/path/to/view/:param')
    def myview(req, param):
        return 'something'



## Run

    gunicorn path.to.your:app -b 0.0.0.0:3579 -k utilery.worker.Worker -w 4
