class Comment{
    static jsonRender(data){
        const locals = JSON.parse(data)
        const comment = $('<div></div>').toggleClass('comment').attr('id', `comment-${locals.comment.id}`)

        comment
            .append(`<p>Author: ${locals.author.email}</p>`)
            .append(`<p>Text: ${locals.comment.body}</p>`)

        return comment
    }
}

export default Comment