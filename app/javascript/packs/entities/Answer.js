class Answer{
    constructor(){
        this.formEdit()
        this.bestAnswer()
    }

    formEdit() {
        $('.answers').on('click', '.edit-answer-link', event => {
            const answerId = $(event.target).data('answerId')

            event.preventDefault();
            $(event.target).hide();
            $('form#edit-answer-' + answerId).removeClass('hidden')
        })
    }

    bestAnswer() {
        $('.answer').first().before($(".best-answer"))
    }
}

export default Answer