import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { CreatePostDto } from './dto/create-post.dto';
import { UpdatePostDto } from './dto/update-post.dto';
import { Repository, Connection } from 'typeorm';
import { Post } from "./entities/post.entity";

@Injectable()
export class PostsService {
  constructor(
    @InjectRepository(Post)
    private readonly model: Repository<Post>,
  ) {}

  create(createPostDto: CreatePostDto) {
    const post = new Post();
    post.title = createPostDto.title;
    post.content = createPostDto.content;

    return this.model.save(post);
  }

  findAll() {
    return this.model.find();
  }

  findOne(id: number) {
    return this.model.findOne(id);
  }

  update(id: number, updatePostDto: UpdatePostDto) {
    return this.model.update({ id }, updatePostDto);
  }

  async remove(id: number) {
    await this.model.delete(id);
  }
  
}
