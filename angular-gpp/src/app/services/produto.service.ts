import { environment } from 'src/environments/environment';
import { Injectable } from '@angular/core';
import { ProdutoModel } from '../models/ProdutoModel';
import { Observable } from 'rxjs';
import { HttpClient } from '@angular/common/http';


@Injectable({
  providedIn: 'root'
})
export class ProdutoService {

  public produtos: ProdutoModel[] = [];

  constructor(private httpClient: HttpClient) { }

  public post(produto: ProdutoModel): Observable<any>{
    return this.httpClient.post(`${environment.url}/produto/`, produto);
  }

  public add(produto: ProdutoModel): Observable<any>{
    return this.httpClient.post(`${environment.url}/produto/`, produto);
  }

  public get(idx: number): Observable<any>{
    return this.httpClient.get(`${environment.url}/produto/${idx}`);
    
  }

  public list(): Observable<any>{
    // console.log(this.httpClient.get(`${environment.url}/produto/`))
    return this.httpClient.get(`${environment.url}/produto/`);
  }

  public delete(id: number): Observable<any>{
    return this.httpClient.delete(`${environment.url}/produto/${id}`);
  }

}
