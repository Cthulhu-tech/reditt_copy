import { BrowserRouter, Route, Routes } from 'react-router-dom';

import { Registration } from './views/registration/registration';
import { Login } from './views/login/login';
import { Post } from './views/post/post';

export const App = () => {

    return <BrowserRouter>
        <Routes>
            <Route path="/login" element={<Login/>}/>
            <Route path="/registration" element={<Registration/>}/>
            <Route path="/post/:id" element={<Post/>}/>
        </Routes>
    </BrowserRouter>

}
