import React from 'react'
import ReactDOM from 'react-dom'
import Chatkit from '@pusher/chatkit'


const tokenUrl = "https://us1.pusherplatform.io/services/chatkit_token_provider/v1/066678e6-e662-4263-8deb-49c91992eed9/token"

const instanceLocator = "v1:us1:066678e6-e662-4263-8deb-49c91992eed9"


function Message(props) {
    return (
        <div className="message">
            <div className="message-username">{props.username}</div>
            <div className="messaje-text">{props.text}</div>
        </div>
    )
}

class MessageList extends React.Component {
    render() {
        return (
            <div className="message-list">
                {this.props.messages.map((message, index) => {
                    return (
                        <Message key={index} username={message.senderId} text={message.text} />
                    )
                })}
            </div>
        )
    }

}

class SendMessageForm extends React.Component {

    constructor(){
        super()
        this.state = {
            message: ''
        }
        this.handleChange = this.handleChange.bind(this);
        this.handleSubmit = this.handleSubmit.bind(this);
    }

    handleChange(e){
        this.setState({
            message: e.target.value 
        })
    }

    handleSubmit(e){
        e.preventDefault()
        this.props.sendMessage(this.state.message)
        this.setState({
            message: ''
        })
    }

    render() {
        return (
            <form
                onSubmit = {this.handleSubmit} 
                className = "send-menssage-form">
                <input
                    onChange = {this.handleChange}
                    value = {this.state.message}
                    placeholder = "Escribe tu mensaje y preciona enter"
                    type = "text"
                />
            </form>
        )
    }

}

class RoomList extends React.Component {
    render() {
        return (
            <div className = "rooms-list" >
            <ul>
                <h3>Buzon de mensajes</h3>
            {this.props.rooms.map(room => {
                    return(
                        <li key = {room.id} className = "room">
                            <a 
                                onClick={() => this.props.subscribeToRoom(room.id)}
                                href = "#">
                                # {room.name}
                            </a>
                        </li>
                    )
                })}
            </ul>
                
            </div>
        )
    }

}

class NewRoomForm extends React.Component {
    render() {
        return (
            <div >

            </div>
        )
    }

}

class Root extends React.Component {

    constructor() {
        super()
        this.state = {
            messages: [],
            joinableRooms: [],
            joinedRooms: []
        }
        this.sendMessage = this.sendMessage.bind(this)
        this.subscribeToRoom = this.subscribeToRoom.bind(this)
        this.getRooms = this.getRooms.bind(this)
    }

    componentDidMount() {
        const chatManager = new Chatkit.ChatManager({
            instanceLocator,
            userId: '1',
            tokenProvider: new Chatkit.TokenProvider({
                url: tokenUrl
            })
        })

        chatManager.connect()
            .then(currentUser => {
                this.currentUser = currentUser
                this.getRooms()
                
            })
            .catch(err => console.log('error on connecting: ', errrr))
    }


    getRooms(){
        this.currentUser.getJoinableRooms()
                .then(joinableRooms => {
                    this.setState({
                        joinableRooms,
                        joinedRooms: this.currentUser.rooms
                    })
                })
                .catch(err => console.log('error on joinableRooms: ', errrr))
    }

    subscribeToRoom(roomId){
        this.currentUser.subscribeToRoom({
            roomId: roomId,
            hooks: {
                onNewMessage: message => {
                    this.setState({
                        messages: [...this.state.messages, message]
                    })
                }
            }
        })
    }

    sendMessage(text){
        this.currentUser.sendMessage({
            text,
            roomId: 19388559 
        })
    }

    render() {
        return (
            <div className="appMessages">
                <RoomList 
                    subscribeToRoom={this.subscribeToRoom}  
                    rooms = {[...this.state.joinableRooms, ...this.state.joinedRooms]} />
                <MessageList messages = {this.state.messages} />
                <SendMessageForm sendMessage = {this.sendMessage} />
                <NewRoomForm />
            </div>
        )
    }
}

document.addEventListener('DOMContentLoaded', () => {
    ReactDOM.render(
        <Root />,
        document.getElementById("home-index")
    )
})
