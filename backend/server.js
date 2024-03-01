const express = require('express');

const app = express();

const mysql = require('mysql');



// database connection
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'socket'
});

db.connect((err) => {
    if (err) {
        console.error('Error connecting to database:', err);
        return;
    }
    console.log('Connected to database');
});


const port = process.env.PORT || 3000;

// server connection
const server = app.listen(port, () => {
    console.log('Server is started on port 3000');
});

const io = require('socket.io')(server);


let user_socket = new Map();

let active_users = [];


// initializing the server
io.on('connection', (socket) => {

    // Function to remove entry with given socket ID
    function removeBySocketId(socketIdToRemove) {
        user_socket.forEach((value, key) => {
            if (value === socketIdToRemove) {
                user_socket.delete(key);
            }
        });
    }
    // Function to remove disconnected user from active users list
    function removeUserFromActiveUsers(socketID) {
        user_socket.forEach((value, key) => {
            console.log('you are here ');
            console.log(value + '    ' + key);
            if (value === socketID) {
                for (let i = 0; i < active_users.length; i++) {
                    const element = active_users[i];
                    console.log('element');
                    console.log(element);
                    if (element['user_id'] === key) {
                        console.log(element['user_id']);
                        console.log('element', element);
                        let index = active_users.indexOf(element)
                        console.log(index);
                        active_users.splice(index, 1)
                    }
                }
            }
        });
    }

    socket.on('disconnect', () => {
        console.log('Client requested disconnect');

        // Call the function to remove entry with socket ID = '12'

        removeUserFromActiveUsers(socket.id);
        removeBySocketId(socket.id);
        console.log('active users list');
        socket.broadcast.emit('activeuserslist', active_users)
        socket.disconnect();
        // deleting disconnected user from active users
    });


    socket.broadcast.emit('activeuserslist', active_users)



    socket.on('mappingsockets', (data) => {
        user_socket.set(data, socket.id)
    })

    socket.on('logout', () => {

        removeUserFromActiveUsers(socket.id);
        removeBySocketId(socket.id);
        console.log('active users list');
        socket.broadcast.emit('activeuserslist', active_users)
    })




    console.log('Someone logged onto the server', socket.id);

    socket.on('signup', (data) => {

        let sql = 'INSERT INTO `users`( `user_firstname`, `user_secondname`, `user_email`, `user_password`) VALUES (?,?,?,?)'
        db.query(sql, [data.firstname, data.secondname, data.email, data.password], (err, result) => {
            if (err) {
                console.log(err);
            } else {
                let sql2 = 'SELECT * FROM users WHERE user_email = ? and user_password = ?';
                db.query(sql2, [data.email, data.password], (err, result2) => {
                    if (err) {
                        console.log('error fetching data of user that just signed up ', err);
                    } else {

                        socket.emit('signupcheck', { 'status': 'Signed up successfully', 'response': result2 });
                        active_users.push(result2[0]),
                            socket.broadcast.emit('activeuserslist', active_users)
                    }
                })
            }
        },);

    });

    socket.on('login', (data) => {

        let sql = 'SELECT * FROM users WHERE user_email = ? and user_password = ?';
        db.query(sql, [data.email, data.password], (err, result) => {
            if (err) {
                console.log(err);
            } else {
                if (result.length === 0) {
                    socket.emit('logincheck', 'invalid');
                } else {
                    socket.emit('logincheck', result);
                    let akhna = result[0].user_id;
                    socket.emit('activeuserslist', active_users);

                    active_users.push(result[0]),
                        socket.broadcast.emit('activeuserslist', active_users);
                    FetchChatsToHomePage(akhna, socket);
                }
            }
        })
    })

    // u still have to do checking existing conversation part
    socket.on('createconvo', (data) => {
        let sqlcheck = 'SELECT conversationid FROM participant WHERE userid = ? AND conversationid IN ( SELECT conversationid FROM participant WHERE userid = ? ) '
        db.query(sqlcheck, [data.usera, data.userb], (fail, success) => {
            if (fail) {
                console.log('fail checking existing conversation', fail);
            } else {
                if (success.length === 0) {
                    let sql = 'INSERT INTO `conversation`(`lastmessage`, `islastmessageseen`) VALUES (? , ?)'
                    db.query(sql, [data.lastmessage, data.islastmessageseen], (err, result) => {
                        if (err) {
                            console.log('error inserting new convo ', err);
                        } else {
                            socket.emit('updateconvoid', result.insertId)
                            // insert participants to convo

                            let partcipantASQL = 'INSERT INTO `participant`( `conversationid`, `userid`) VALUES (? , ?)'
                            db.query(partcipantASQL, [result.insertId, data.usera]);

                            let partcipant2ASQL = 'INSERT INTO `participant`( `conversationid`, `userid`) VALUES (? , ?)'
                            db.query(partcipant2ASQL, [result.insertId, data.userb]);

                            // fetch messages
                            fetchMsgsSql = 'SELECT * FROM `message` WHERE conversationid = ?'
                            db.query(fetchMsgsSql, [result.insertId], (err2, result2) => {
                                if (err2) {
                                    console.log('error fetching messages ', err2);
                                } else {
                                    socket.emit('updatemessageslist', {
                                        'messages': result2,
                                        'conversationid': result.insertId,
                                    })
                                }
                            })

                        }
                    })
                } else {
                    let convoid = success[0].conversationid;
                    socket.emit('updateconvoid', convoid)
                    // fetch messages
                    fetchMsgsSql = 'SELECT * FROM `message` WHERE conversationid = ?'
                    db.query(fetchMsgsSql, [convoid], (err2, messages) => {
                        if (err2) {
                            console.log('error fetching messages ', err2);
                        } else {
                            socket.emit('updatemessageslist', {
                                'messages': messages,
                                'conversationid': convoid,
                            })
                        }
                    })
                }



            }
        })
    })

    socket.on('changeusertotextchatlist', (data) => {
        let fetchSocketSql = 'SELECT userid FROM `participant` WHERE participant.conversationid = ? AND participant.userid != ?'
        let useridcrspnd;
        let socketToText;
        db.query(fetchSocketSql, [data.conversationid, data.sender], (fail, success) => {



            useridcrspnd = success[0].userid;
            socketToText = user_socket.get(useridcrspnd)

            let fetchChatsSql = `SELECT 
            C.id,
            C.lastmessage,
            C.islastmessageseen,
            U.user_id,
            U.user_firstname,
            U.user_secondname,
            U.user_email
            FROM conversation C
            JOIN participant P ON P.conversationid = C.id
            JOIN users U ON U.user_id = P.userid
            WHERE C.id IN (
                SELECT M.conversationid FROM participant M WHERE M.userid = ?
            )`;
            db.query(fetchChatsSql, [useridcrspnd], (err, result) => {
                socket.to(socketToText).emit('updateChatsListNow', result);
            });

        })
    });

    socket.on('sendmessage', (data) => {
        let sql = 'INSERT INTO `message`( `sender`, `conversationid`, `content`) VALUES (? , ? , ?)'
        db.query(sql, [data.sender, data.conversationid, data.content], (err, result) => {
            if (err) {
                console.log('error sending a message ', err);
            } else {
                let updateLastMessageInConvo = 'UPDATE `conversation` SET `lastmessage`=? WHERE id = ? '
                db.query(updateLastMessageInConvo, [data.content, data.conversationid], (first, second) => {
                    if (first) {
                        console.log('failed updated last message in convo');
                    } else {
                        console.log('updated last message in convo succefully');
                    }
                });
                fetchMsgsSql = 'SELECT * FROM `message` WHERE conversationid = ?'
                db.query(fetchMsgsSql, [data.conversationid], (err2, result2) => {
                    if (err2) {
                        console.log('error fetching messages ', err2);
                    } else {
                        let socketToText;
                        let useridcrspnd;
                        let fetchSocketSql = 'SELECT userid FROM `participant` WHERE participant.conversationid = ? AND participant.userid != ?'
                        db.query(fetchSocketSql, [data.conversationid, data.sender], (fail, success) => {
                            useridcrspnd = success[0].userid;
                            socketToText = user_socket.get(useridcrspnd)

                            socket.to(socketToText).emit('updatemessageslist', {
                                'messages': result2,
                            });
                        })
                        socket.emit('updatemessageslist', {
                            'messages': result2,
                        })
                        FetchChatsToHomePage(data.sender, socket);
                        FetchChatsToHomePageToReciever(useridcrspnd, socket, socketToText);

                    }
                })
            }
        })
    });


    socket.on('onlinestatus' , data => {
        console.log('borhaaaaaaaaaaaan');
        if (!user_socket.has(data)) {
            console.log('u here' , user_socket.get(data));
            socket.emit('onlinestatuspart' , 'offline');
        } else {
            console.log('else u here');
            socket.emit('onlinestatuspart' , 'online');
            
        }
    })

    socket.on('useristyping', (data) => {
        let fetchSocketSql = 'SELECT userid FROM `participant` WHERE participant.conversationid = ? AND participant.userid != ?'
        db.query(fetchSocketSql, [data.conversationid, data.sender], (fail, success) => {
            let useridcrspnd = success[0].userid;
            let socketToText = user_socket.get(useridcrspnd)
            console.log(socketToText);

            socket.to(socketToText).emit('borhantyping');
        })

    })

    socket.on('nottypinganymore', (data) => {
        let fetchSocketSql = 'SELECT userid FROM `participant` WHERE participant.conversationid = ? AND participant.userid != ?'
        db.query(fetchSocketSql, [data.conversationid, data.sender], (fail, success) => {
            let useridcrspnd = success[0].userid;
            let socketToText = user_socket.get(useridcrspnd)
            console.log(socketToText);

            socket.to(socketToText).emit('changetyping');
        })

    })






});

function FetchChatsToHomePage(akhna, socket) {
    let fetchChatsSql = `SELECT 
                    C.id,
                    C.lastmessage,
                    C.islastmessageseen,
                    C.lastsentat,
                    U.user_id,
                    U.user_firstname,
                    U.user_secondname,
                    U.user_email
                    FROM conversation C
                    JOIN participant P ON P.conversationid = C.id
                    JOIN users U ON U.user_id = P.userid
                    WHERE C.id IN (
                        SELECT M.conversationid FROM participant M WHERE M.userid = ?
                    ) ORDER BY lastsentat DESC`;
    db.query(fetchChatsSql, [akhna], (err, result) => {
        console.log('chats :', result);
        socket.emit('chats', result);
    });
}
function FetchChatsToHomePageToReciever(akhna, socket, socketToText) {
    let fetchChatsSql = `SELECT 
                    C.id,
                    C.lastmessage,
                    C.islastmessageseen,
                    C.lastsentat,
                    U.user_id,
                    U.user_firstname,
                    U.user_secondname,
                    U.user_email
                    FROM conversation C
                    JOIN participant P ON P.conversationid = C.id
                    JOIN users U ON U.user_id = P.userid
                    WHERE C.id IN (
                        SELECT M.conversationid FROM participant M WHERE M.userid = ?
                    ) ORDER BY lastsentat DESC`;
    db.query(fetchChatsSql, [akhna], (err, result) => {
        console.log('chats :', result);
        socket.to(socketToText).emit('chats', result);
    });
}
