const express = require('express');
const http = require('http');
const { Server } = require('socket.io');

const app = express();
const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: '*',
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
  }
});

let todos = []; 

io.on('connection', (socket) => {
  console.log('✅ User connected:', socket.id);

 

  // get todos
  socket.on('getTodos', () => {
    console.log('📥 getTodos requested by:', socket.id);
    socket.emit('todosList', todos); // ✅ Matches what Flutter expects
    socket.emit('todosCount', todos.length);
  });

  // ✅ Add todo
  socket.on('addTodo', (todo) => {
    todos.push(todo);
    console.log(' Todo added:', todo);

    io.emit('todoAdded', todo);      
    io.emit('todosList', todos);    
    io.emit('todosCount', todos.length); 
  });

  // ✅ Update todo
  socket.on('updateTodo', (updatedTodo) => {
    todos = todos.map(todo =>
      todo.id === updatedTodo.id ? updatedTodo : todo
    );
    console.log('✏️ Todo updated:', updatedTodo);

    io.emit('todoUpdated', updatedTodo);
    io.emit('todosCount', todos.length); 
  });

  // ✅ Delete todo
  socket.on('deleteTodo', (id) => {
    todos = todos.filter(todo => todo.id !== id);
    console.log('❌ Todo deleted:', id);

    io.emit('todoDeleted', id);
    io.emit('todosCount', todos.length);
  });

  socket.on('disconnect', () => {
    console.log(' User disconnected:', socket.id);
  });
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
  console.log(` Socket.IO server running on port ${PORT}`);
});
