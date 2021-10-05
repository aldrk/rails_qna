import consumer from "./consumer"
import Comment from '../packs/entities/Comment'

consumer.subscriptions.create("CommentChannel", {
    connected() {},

    disconnected() {},

    received(data) {
        const comment = Comment.jsonRender(data)
        data = JSON.parse(data)
        $(`#${data.resource_name}-${data.resource_id}`).find('.comments').append(comment)
    }
})